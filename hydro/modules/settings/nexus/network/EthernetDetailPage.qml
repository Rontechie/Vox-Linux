import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    readonly property var dev: NxNmcli.activeEthernet ?? (NxNmcli.ethernetDevices.length > 0 ? NxNmcli.ethernetDevices[0] : null)
    readonly property bool connected: dev ? dev.connected : false
    readonly property var det: NxNmcli.details
    property bool busy: false
    property string error: ""

    function reload() {
        NxNmcli.refreshEthernet(() => {
            if (page.dev) {
                NxNmcli.loadEthernetExtras(page.dev.iface);
                if (page.connected) NxNmcli.loadDetails(page.dev.iface, null);
            }
        });
    }
    Component.onCompleted: reload()
    Timer { interval: 4000; running: true; repeat: true; onTriggered: page.reload() }

    NxGroup {
        NxInfoRow {
            icon: "lan"; text: page.dev ? page.dev.iface : "Ethernet"
            value: !page.dev ? Translation.tr("No adapter") : page.connected ? Translation.tr("Connected") : Translation.tr("Not connected")
        }
        NxButtonRow {
            visible: page.dev !== null
            icon: page.connected ? "link_off" : "link"
            text: page.connected ? Translation.tr("Disconnect") : Translation.tr("Connect")
            subtext: page.dev && page.dev.connection.length > 0 ? page.dev.connection : ""
            pill: page.connected ? "" : Translation.tr("Connect")
            busy: page.busy; disabled: page.busy
            onClicked: {
                page.busy = true;
                page.error = "";
                const done = r => {
                    page.busy = false;
                    if (!(r && r.success)) page.error = Translation.tr("Could not change the connection");
                    page.reload();
                };
                if (page.connected) NxNmcli.disconnectEthernet(page.dev.connection, done);
                else NxNmcli.connectEthernet(page.dev.connection, page.dev.iface, done);
            }
        }
        NxInfoRow {
            visible: page.error.length > 0
            icon: "error"; text: page.error; value: ""
        }
    }

    NxHeader { visible: page.connected; text: Translation.tr("Link") }
    NxGroup {
        visible: page.connected
        NxInfoRow { visible: NxNmcli.ethernetSpeed.length > 0; icon: "speed"; text: Translation.tr("Link speed"); value: NxNmcli.ethernetSpeed }
        NxInfoRow { visible: NxNmcli.ethernetUsage.length > 0; icon: "swap_vert"; text: Translation.tr("Traffic since boot"); value: NxNmcli.ethernetUsage }
        NxInfoRow { visible: !!page.det.mac; icon: "memory"; text: Translation.tr("MAC address"); value: page.det.mac ?? "" }
    }

    NxHeader { visible: page.connected && !!page.det.ipAddress; text: Translation.tr("Addresses") }
    NxGroup {
        visible: page.connected && !!page.det.ipAddress
        NxInfoRow { icon: "pin"; text: Translation.tr("IP address"); value: page.det.ipAddress ?? "" }
        NxInfoRow { visible: !!page.det.subnet; icon: "grid_3x3"; text: Translation.tr("Subnet mask"); value: page.det.subnet ?? "" }
        NxInfoRow { visible: !!page.det.gateway; icon: "router"; text: Translation.tr("Gateway"); value: page.det.gateway ?? "" }
        NxInfoRow { visible: (page.det.dns ?? []).length > 0; icon: "dns"; text: "DNS"; value: (page.det.dns ?? []).join(", ") }
    }

    NxHeader { visible: page.dev !== null && page.dev.connection.length > 0; text: Translation.tr("IP settings") }
    Loader {
        Layout.fillWidth: true
        active: page.dev !== null && page.dev.connection.length > 0
        visible: active
        sourceComponent: NwIpForm { connection: page.dev ? page.dev.connection : "" }
    }
}
