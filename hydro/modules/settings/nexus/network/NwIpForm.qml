import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxGroup {
    id: form
    property string connection: ""
    property bool loaded: false
    property bool saving: false
    property string error: ""
    property bool autoconnect: true

    property string method: "auto"        // "auto" | "auto-dns" | "manual"
    property string address: ""
    property string gateway: ""
    property string dns: ""
    property string origMethod: "auto"
    property string origAddress: ""
    property string origGateway: ""
    property string origDns: ""

    readonly property bool showDns: method === "manual" || method === "auto-dns"
    readonly property bool hasChanges: loaded && (method !== origMethod
        || (method === "manual" && (address.trim() !== origAddress || gateway.trim() !== origGateway))
        || (showDns && dns.trim() !== origDns))

    function load(): void {
        if (connection.length === 0) return;
        NxNmcli.getIpv4(connection, cfg => {
            if (!cfg) return;
            form.method = cfg.method;
            form.address = cfg.address;
            form.gateway = cfg.gateway;
            form.dns = cfg.dns;
            form.autoconnect = cfg.autoconnect;
            form.origMethod = cfg.method;
            form.origAddress = cfg.address;
            form.origGateway = cfg.gateway;
            form.origDns = cfg.dns;
            form.error = "";
            form.loaded = true;
        });
    }

    function save(): void {
        error = "";
        if (method === "manual") {
            if (!NwUtil.isIpv4(address, true)) { error = Translation.tr("Address must look like 192.168.1.20/24"); return; }
            if (gateway.trim().length > 0 && !NwUtil.isIpv4(gateway, false)) { error = Translation.tr("Gateway is not a valid IPv4 address"); return; }
        }
        if (showDns && !NwUtil.validDnsList(dns)) { error = Translation.tr("DNS servers must be IPv4 addresses separated by commas"); return; }
        saving = true;
        NxNmcli.setIpv4(connection, { method: method, address: address.trim(), gateway: gateway.trim(), dns: dns.trim() }, r => {
            form.saving = false;
            if (!(r && r.success)) {
                form.error = Translation.tr("Could not apply settings");
                return;
            }
            form.origMethod = form.method;
            form.origAddress = form.address.trim();
            form.origGateway = form.gateway.trim();
            form.origDns = form.dns.trim();
        });
    }

    onConnectionChanged: { loaded = false; load() }
    Component.onCompleted: load()

    NxSelectRow {
        icon: "lan"; text: Translation.tr("IP configuration")
        model: [
            { value: "auto", label: Translation.tr("Automatic (DHCP)") },
            { value: "auto-dns", label: Translation.tr("Automatic + custom DNS") },
            { value: "manual", label: Translation.tr("Manual") }
        ]
        current: form.method
        disabled: !form.loaded
        onPicked: v => form.method = v
    }
    NxTextRow {
        visible: form.method === "manual"
        icon: "pin"; text: Translation.tr("IP address"); placeholder: "192.168.1.20/24"
        value: form.address
        onEdited: v => form.address = v
    }
    NxTextRow {
        visible: form.method === "manual"
        icon: "router"; text: Translation.tr("Gateway"); placeholder: "192.168.1.1"
        value: form.gateway
        onEdited: v => form.gateway = v
    }
    NxTextRow {
        visible: form.showDns
        icon: "dns"; text: Translation.tr("DNS servers"); placeholder: "1.1.1.1, 8.8.8.8"
        value: form.dns
        onEdited: v => form.dns = v
    }
    NxInfoRow {
        visible: form.error.length > 0
        icon: "error"; text: form.error; value: ""
    }
    NxButtonRow {
        visible: form.hasChanges
        icon: "check"; text: Translation.tr("Apply changes"); subtext: Translation.tr("Reconnects to apply")
        pill: Translation.tr("Apply"); accent: true
        busy: form.saving; disabled: form.saving
        onClicked: form.save()
    }
}
