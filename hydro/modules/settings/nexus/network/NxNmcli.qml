pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var savedWifi: []            // [{ name, ssid }]
    property var ethernetDevices: []      // [{ iface, state, connection, connected }]
    property var vpnProfiles: []          // [{ name, type, device, active }]
    property var details: ({})            // last `device show` result, see parseDetails
    property string ethernetSpeed: ""
    property string ethernetUsage: ""
    readonly property bool hasEthernet: ethernetDevices.some(d => d.state !== "unavailable")
    readonly property var activeEthernet: ethernetDevices.find(d => d.connected) ?? null
    readonly property bool vpnConnected: vpnProfiles.some(p => p.active)

    Component {
        id: cmdComp
        Process {
            id: proc
            property var callback: null
            property string out: ""
            property bool exited: false
            property bool collected: false
            property int code: 0
            function finish(): void {
                if (!exited || !collected) return;
                const cb = callback;
                callback = null;
                if (cb) cb({ success: code === 0, output: out, error: code === 0 ? "" : out, exitCode: code });
                proc.destroy();
            }
            environment: ({ LANG: "C", LC_ALL: "C" })
            stdout: StdioCollector {
                onStreamFinished: { proc.out = text; proc.collected = true; proc.finish() }
            }
            onExited: (exitCode, exitStatus) => { proc.code = exitCode; proc.exited = true; proc.finish() }
        }
    }

    function run(args: var, callback: var): void {
        const p = cmdComp.createObject(root, { callback: callback });
        p.command = ["sh", "-c", 'nmcli "$@" 2>&1', "sh"].concat(args);
        p.running = true;
    }

    function runShell(script: string, callback: var): void {
        const p = cmdComp.createObject(root, { callback: callback });
        p.command = ["sh", "-c", script + " 2>&1"];
        p.running = true;
    }

    function splitTerse(line: string): var {
        const parts = [];
        let cur = "";
        for (let i = 0; i < line.length; i++) {
            const c = line[i];
            if (c === "\\" && i + 1 < line.length) { cur += line[i + 1]; i++; }
            else if (c === ":") { parts.push(cur); cur = ""; }
            else cur += c;
        }
        parts.push(cur);
        return parts;
    }

    function fail(callback: var, msg: string): void {
        if (callback) callback({ success: false, output: "", error: msg, exitCode: -1 });
    }

    function loadSaved(callback: var): void {
        run(["-t", "-f", "NAME,TYPE", "connection", "show"], r => {
            const list = [];
            if (r.success) {
                for (const line of r.output.trim().split("\n")) {
                    const p = splitTerse(line);
                    if (p.length >= 2 && p[1] === "802-11-wireless" && p[0].length > 0) list.push({ name: p[0], ssid: p[0] });
                }
            }
            list.sort((a, b) => a.name.localeCompare(b.name));
            root.savedWifi = list;
            if (callback) callback(list);
        });
    }

    function hasSaved(ssid: string): bool {
        return savedWifi.some(c => c.name.toLowerCase() === ssid.toLowerCase());
    }

    function forget(name: string, callback: var): void {
        if (!name) { fail(callback, "No connection specified"); return; }
        run(["connection", "delete", name], r => { root.loadSaved(null); if (callback) callback(r) });
    }

    function getAutoconnect(name: string, callback: var): void {
        run(["-t", "-f", "connection.autoconnect", "connection", "show", name], r => {
            let auto = true;
            if (r.success) {
                const i = r.output.indexOf(":");
                if (i >= 0) auto = r.output.slice(i + 1).trim() !== "no";
            }
            if (callback) callback(auto);
        });
    }

    function setAutoconnect(name: string, enabled: bool, callback: var): void {
        if (!name) { fail(callback, "No connection specified"); return; }
        run(["connection", "modify", name, "connection.autoconnect", enabled ? "yes" : "no"], callback);
    }

    function addNetwork(ssid: string, password: string, hidden: bool, callback: var): void {
        if (!ssid) { fail(callback, "No SSID specified"); return; }
        run(["connection", "delete", ssid], () => {
            const cmd = ["connection", "add", "type", "wifi", "con-name", ssid, "ifname", "*", "ssid", ssid, "802-11-wireless.hidden", hidden ? "yes" : "no"];
            if (password.length > 0) cmd.push("wifi-sec.key-mgmt", "wpa-psk", "wifi-sec.psk", password);
            run(cmd, r => {
                if (!r.success) { if (callback) callback(r); return; }
                root.loadSaved(null);
                run(["connection", "up", ssid], callback);
            });
        });
    }

    function getIpv4(name: string, callback: var): void {
        if (!name) { if (callback) callback(null); return; }
        run(["-t", "-f", "ipv4.method,ipv4.addresses,ipv4.gateway,ipv4.dns,ipv4.ignore-auto-dns,connection.autoconnect", "connection", "show", name], r => {
            if (!r.success) { if (callback) callback(null); return; }
            const cfg = { method: "auto", address: "", gateway: "", dns: "", ignoreAutoDns: false, autoconnect: true };
            for (const line of r.output.trim().split("\n")) {
                const i = line.indexOf(":");
                if (i < 0) continue;
                const key = line.slice(0, i).trim();
                const value = line.slice(i + 1).trim();
                if (key === "ipv4.ignore-auto-dns") cfg.ignoreAutoDns = value === "yes";
                else if (key === "connection.autoconnect") cfg.autoconnect = value !== "no";
                if (value === "" || value === "--") continue;
                if (key === "ipv4.method") cfg.method = value;
                else if (key === "ipv4.addresses") cfg.address = value.split(",")[0].trim();
                else if (key === "ipv4.gateway") cfg.gateway = value;
                else if (key === "ipv4.dns") cfg.dns = value.replace(/;\s*$/, "").split(/[;,]/).map(d => d.trim()).filter(d => d.length > 0).join(", ");
            }
            if (cfg.method === "auto" && cfg.ignoreAutoDns) cfg.method = "auto-dns";
            if (callback) callback(cfg);
        });
    }

    function setIpv4(name: string, cfg: var, callback: var): void {
        if (!name) { fail(callback, "No connection specified"); return; }
        const dns = (cfg.dns ?? "").split(",").map(d => d.trim()).filter(d => d.length > 0).join(" ");
        const cmd = ["connection", "modify", name];
        if (cfg.method === "manual") {
            cmd.push("ipv4.method", "manual", "ipv4.addresses", cfg.address ?? "", "ipv4.gateway", cfg.gateway ?? "", "ipv4.dns", dns, "ipv4.ignore-auto-dns", "yes");
        } else if (cfg.method === "auto-dns") {
            cmd.push("ipv4.method", "auto", "ipv4.addresses", "", "ipv4.gateway", "", "ipv4.dns", dns, "ipv4.ignore-auto-dns", "yes");
        } else {
            cmd.push("ipv4.method", "auto", "ipv4.addresses", "", "ipv4.gateway", "", "ipv4.dns", "", "ipv4.ignore-auto-dns", "no");
        }
        run(cmd, r => {
            if (!r.success) { if (callback) callback(r); return; }
            run(["connection", "up", name], callback); // reactivate so it applies now
        });
    }

    function cidrToMask(bits: int): string {
        const n = Math.max(0, Math.min(32, bits));
        const m = n === 0 ? 0 : (0xFFFFFFFF << (32 - n)) >>> 0;
        return [(m >>> 24) & 255, (m >>> 16) & 255, (m >>> 8) & 255, m & 255].join(".");
    }

    function parseDetails(output: string): var {
        const d = { ipAddress: "", subnet: "", gateway: "", dns: [], mac: "", state: "", connection: "" };
        for (const line of output.trim().split("\n")) {
            const i = line.indexOf(":");
            if (i < 0) continue;
            const key = line.slice(0, i).trim();
            const value = line.slice(i + 1).replace(/\\:/g, ":").trim();
            if (value === "" || value === "--") continue;
            if (key.startsWith("IP4.ADDRESS")) {
                const p = value.split("/");
                d.ipAddress = p[0];
                d.subnet = p[1] ? cidrToMask(parseInt(p[1])) : "";
            } else if (key === "IP4.GATEWAY") d.gateway = value;
            else if (key.startsWith("IP4.DNS")) d.dns.push(value);
            else if (key === "GENERAL.HWADDR") d.mac = value;
            else if (key === "GENERAL.STATE") d.state = value;
            else if (key === "GENERAL.CONNECTION") d.connection = value;
        }
        return d;
    }

    function loadDetails(iface: string, callback: var): void {
        const go = name => run(["-t", "device", "show", name], r => {
            const d = r.success ? root.parseDetails(r.output) : ({});
            root.details = d;
            if (callback) callback(d);
        });
        if (iface) { go(iface); return; }
        run(["-t", "-f", "DEVICE,TYPE,STATE", "device", "status"], r => {
            let name = "";
            for (const line of r.output.trim().split("\n")) {
                const p = splitTerse(line);
                if (p.length >= 3 && p[1] === "wifi" && p[2] === "connected") { name = p[0]; break; }
            }
            if (name) go(name); else { root.details = ({}); if (callback) callback({}) }
        });
    }

    function refreshEthernet(callback: var): void {
        run(["-t", "-f", "DEVICE,TYPE,STATE,CONNECTION", "device", "status"], r => {
            const found = [];
            if (r.success) {
                for (const line of r.output.trim().split("\n")) {
                    const p = splitTerse(line);
                    if (p.length >= 3 && p[1] === "ethernet") found.push({ iface: p[0], state: p[2], connection: p[3] ?? "", connected: p[2] === "connected" });
                }
            }
            if (found.length === 0) { root.ethernetDevices = []; if (callback) callback([]); return; }
            const script = 'for i in ' + found.map(f => "'" + f.iface.replace(/'/g, "") + "'").join(" ")
                + '; do [ -e "/sys/class/net/$i/device" ] && echo "$i"; done; exit 0';
            runShell(script, pr => {
                const phys = pr.output.trim().split("\n").filter(l => l.length > 0);
                const list = pr.success && phys.length > 0 ? found.filter(f => phys.indexOf(f.iface) >= 0) : found;
                root.ethernetDevices = list;
                if (callback) callback(list);
            });
        });
    }

    function connectEthernet(connection: string, iface: string, callback: var): void {
        const after = r => { Qt.callLater(() => root.refreshEthernet(null)); if (callback) callback(r) };
        if (connection) run(["connection", "up", connection], after);
        else if (iface) run(["device", "connect", iface], after);
        else fail(callback, "No connection or interface");
    }

    function disconnectEthernet(connection: string, callback: var): void {
        if (!connection) { fail(callback, "No connection specified"); return; }
        run(["connection", "down", connection], r => { root.refreshEthernet(null); if (callback) callback(r) });
    }

    function loadEthernetExtras(iface: string): void {
        if (!iface) { ethernetSpeed = ""; ethernetUsage = ""; return; }
        const safe = iface.replace(/[^A-Za-z0-9_.:-]/g, "");
        runShell("cat /sys/class/net/" + safe + "/speed", r => {
            const n = parseInt(r.output);
            root.ethernetSpeed = r.success && n > 0 ? (n >= 1000 ? (n / 1000) + " Gbps" : n + " Mbps") : "";
        });
        runShell("cat /sys/class/net/" + safe + "/statistics/rx_bytes /sys/class/net/" + safe + "/statistics/tx_bytes", r => {
            const v = r.output.trim().split("\n");
            if (!r.success || v.length < 2) { root.ethernetUsage = ""; return; }
            const fmt = b => { const u = ["B", "KB", "MB", "GB", "TB"]; let i = 0; let x = parseFloat(b); while (x >= 1024 && i < 4) { x /= 1024; i++ } return x.toFixed(i === 0 ? 0 : 1) + " " + u[i] };
            root.ethernetUsage = "↓ " + fmt(v[0]) + "  ↑ " + fmt(v[1]);
        });
    }

    function refreshVpn(callback: var): void {
        run(["-t", "-f", "NAME,TYPE,DEVICE,ACTIVE", "connection", "show"], r => {
            const list = [];
            if (r.success) {
                for (const line of r.output.trim().split("\n")) {
                    const p = splitTerse(line);
                    if (p.length >= 4 && (p[1] === "vpn" || p[1] === "wireguard")) list.push({ name: p[0], type: p[1], device: p[2], active: p[3] === "yes" });
                }
            }
            root.vpnProfiles = list;
            if (callback) callback(list);
        });
    }

    function vpnUp(name: string, callback: var): void {
        run(["connection", "up", name], r => { root.refreshVpn(null); if (callback) callback(r) });
    }

    function vpnDown(name: string, callback: var): void {
        run(["connection", "down", name], r => { root.refreshVpn(null); if (callback) callback(r) });
    }

    function vpnDelete(name: string, callback: var): void {
        run(["connection", "delete", name], r => { root.refreshVpn(null); if (callback) callback(r) });
    }

    function vpnImport(type: string, file: string, callback: var): void {
        if (!file) { fail(callback, "No file selected"); return; }
        const path = file.replace(/^file:\/\//, "").replace(/^~/, Quickshell.env("HOME"));
        run(["connection", "import", "type", type, "file", path], r => { root.refreshVpn(null); if (callback) callback(r) });
    }
}
