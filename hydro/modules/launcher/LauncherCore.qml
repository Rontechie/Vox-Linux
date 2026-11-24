import QtQuick
import Quickshell
import qs
import qs.services
import qs.modules.common

QtObject {
    id: root

    readonly property var cfg: Config.options.launcher
    readonly property HydroPal pal: HydroPal {}
    readonly property real cardW: [420, 500, 580][Math.max(0, Math.min(2, cfg.sizeIdx))]
    readonly property real cardH: 600
    readonly property var shapeNames: ["none", "circle", "square", "cookie9", "cookie12", "sunny", "flower", "clover4"]
    readonly property string iconShapeName: shapeNames[Math.max(0, Math.min(shapeNames.length - 1, cfg.iconShape))]
    readonly property string userName: SystemInfo.username

    property bool settingsOpen: false
    property int rescanTick: 0

    function groupOf(c) {
        const t = c.split(";");
        function has(a) { for (const x of a) if (t.indexOf(x) >= 0) return true; return false }
        if (has(["Game"])) return "Games";
        if (has(["Development", "IDE"])) return "Develop";
        if (has(["Network", "WebBrowser", "Email", "InstantMessaging", "Chat", "FileTransfer"])) return "Internet";
        if (has(["AudioVideo", "Audio", "Video", "Player", "Recorder", "Music"])) return "Media";
        if (has(["Graphics", "Photography"])) return "Graphics";
        if (has(["Office", "Spreadsheet", "WordProcessor", "Presentation"])) return "Office";
        if (has(["System", "Settings", "Utility", "FileManager", "TerminalEmulator", "Monitor", "PackageManager"])) return "System";
        return "Other";
    }

    readonly property var apps: {
        void root.rescanTick; // "Rescan applications" re-reads the list
        const map = {};
        for (const e of DesktopEntries.applications.values) {
            if (e.noDisplay)
                continue;
            const cats = (e.categories ?? []).join(";");
            map[e.id] = {
                id: e.id,
                name: e.name,
                icon: e.icon || "application-x-executable",
                cats: cats,
                kw: ((e.genericName ?? "") + ";" + (e.keywords ?? []).join(";")).toLowerCase(),
                group: groupOf(cats),
                entry: e
            };
        }
        return Object.values(map).sort((a, b) => a.name.localeCompare(b.name));
    }
    readonly property var appIndex: {
        const m = {};
        for (const a of apps) m[a.id] = a;
        return m;
    }
    function appById(id) { return appIndex[id] || null }

    readonly property var favIds: cfg.favorites.split(",").filter(id => id.length > 0 && appById(id) !== null)
    readonly property var recentIds: cfg.recent.split(",").filter(id => id.length > 0 && appById(id) !== null)
    readonly property var groups: {
        const order = ["Internet", "Media", "Develop", "Games", "Graphics", "Office", "System", "Other"];
        const counts = {};
        for (const a of apps) counts[a.group] = (counts[a.group] || 0) + 1;
        const g = ["All"];
        if (recentIds.length > 0) g.push("Recent");
        for (const o of order) if (counts[o]) g.push(o);
        return g;
    }

    function filter(q, cat) {
        q = q.trim().toLowerCase();
        if (q === "") {
            if (cat === "Recent") return recentIds.map(id => appIndex[id]);
            if (cat !== "All") return apps.filter(a => a.group === cat);
            return apps;
        }
        const scored = [];
        for (const a of apps) {
            const n = a.name.toLowerCase();
            let s = -1;
            if (n.indexOf(q) === 0) s = 0;
            else if (n.indexOf(" " + q) >= 0) s = 1;
            else if (n.indexOf(q) >= 0) s = 2;
            else if (a.id.toLowerCase().indexOf(q) >= 0 || a.kw.indexOf(q) >= 0) s = 3;
            if (s >= 0) scored.push([s, a]);
        }
        scored.sort((x, y) => x[0] - y[0] || x[1].name.localeCompare(y[1].name));
        return scored.map(x => x[1]);
    }

    function calc(q) {
        const s = q.replace(/,/g, ".").replace(/\s+/g, "");
        if (!/^[0-9+\-*\/().%^]+$/.test(s) || !/[0-9]/.test(s)) return "";
        if (!/[+\-*\/%^]/.test(s.replace(/^-/, ""))) return "";
        let p = 0;
        function expr() { let v = term(); while (s[p] === "+" || s[p] === "-") { const o = s[p++]; const r = term(); v = o === "+" ? v + r : v - r } return v }
        function term() { let v = unary(); while (s[p] === "*" || s[p] === "/" || s[p] === "%") { const o = s[p++]; const r = unary(); v = o === "*" ? v * r : o === "/" ? v / r : v % r } return v }
        function unary() { if (s[p] === "-") { p++; return -unary() } if (s[p] === "+") { p++; return unary() } return pw() }
        function pw() { const b = atom(); if (s[p] === "^") { p++; return Math.pow(b, unary()) } return b }
        function atom() {
            if (s[p] === "(") { p++; const v = expr(); if (s[p] !== ")") throw "x"; p++; return v }
            const m = /^[0-9]*\.?[0-9]+/.exec(s.slice(p));
            if (!m) throw "x";
            p += m[0].length;
            return parseFloat(m[0]);
        }
        try {
            const v = expr();
            if (p !== s.length || !isFinite(v)) return "";
            return String(Math.round(v * 1e10) / 1e10);
        } catch (e) { return "" }
    }

    function scanApps() { rescanTick++ }
    function closeAll() { settingsOpen = false; GlobalStates.launcherOpen = false }
    function launchApp(a) {
        a.entry.execute();
        const r = recentIds.filter(i => i !== a.id);
        r.unshift(a.id);
        cfg.recent = r.slice(0, 12).join(",");
        closeAll();
    }
    function setFavs(ids) { cfg.favorites = ids.join(",") }
    function toggleFav(id) {
        const f = favIds.slice();
        const i = f.indexOf(id);
        if (i >= 0) f.splice(i, 1);
        else if (f.length < 8) f.push(id);
        else return false;
        setFavs(f);
        return true;
    }
    function runQuery(q) {
        Quickshell.execDetached(["xdg-open", Config.options.search.engineBaseUrl + encodeURIComponent(q)]);
        closeAll();
    }
    function copyText(t) { Quickshell.execDetached(["wl-copy", t]) }
    function power(action) {
        if (action === "lock" && !Config.options.lock.useHyprlock) {
            closeAll();
            GlobalStates.screenLocked = true; // Hydro's own lock, no logind/hypridle needed
            return;
        }
        const cmd = {
            lock: ["hyprlock"],
            sleep: ["systemctl", "suspend"],
            restart: ["systemctl", "reboot"],
            logout: ["hyprctl", "dispatch", "exit"],
            shutdown: ["systemctl", "poweroff"]
        }[action];
        closeAll();
        if (cmd) Quickshell.execDetached(cmd);
    }
    function assignShortcut() {
        copyText("bindr = SUPER, SUPER_L, global, quickshell:launcherToggle");
    }
}
