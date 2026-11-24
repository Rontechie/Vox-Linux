import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    readonly property string ssid: params.ssid ?? ""
    readonly property var ap: Network.wifiNetworks.find(n => n.ssid === ssid) ?? null
    readonly property bool active: ap ? ap.active : false
    readonly property bool saved: NxNmcli.hasSaved(ssid)
    property bool autoconnect: true
    property bool confirmForget: false
    property string error: ""
    readonly property var det: NxNmcli.details

    function reload() {
        NxNmcli.loadSaved(null);
        NxNmcli.getAutoconnect(ssid, v => page.autoconnect = v);
        if (active) NxNmcli.loadDetails("", null);
    }
    Component.onCompleted: reload()
    onActiveChanged: if (active) NxNmcli.loadDetails("", null)

    NxGroup {
        NxInfoRow {
            icon: page.ap ? NwUtil.wifiIcon(page.ap.strength, page.ap.isSecure) : "wifi"
            text: page.ssid
            value: page.active ? Translation.tr("Connected") : page.ap ? Translation.tr("In range") : Translation.tr("Out of range")
        }
        NxButtonRow {
            visible: page.ap !== null
            icon: page.active ? "wifi_off" : "wifi"
            text: page.active ? Translation.tr("Disconnect") : Translation.tr("Connect")
            pill: page.active ? "" : Translation.tr("Connect")
            busy: page.ap !== null && Network.wifiConnecting && Network.wifiConnectTarget === page.ap
            onClicked: page.active ? Network.disconnectWifiNetwork() : Network.connectToWifiNetwork(page.ap)
        }
        NwPasswordRow {
            visible: page.ap !== null && page.ap.askingPassword
            text: Translation.tr("Password for %1").arg(page.ssid)
            placeholder: Translation.tr("Enter password, press Enter")
            onAccepted: v => { if (v.length > 0 && page.ap) Network.changePassword(page.ap, v) }
        }
        NxToggleRow {
            visible: page.saved
            icon: "autorenew"; text: Translation.tr("Connect automatically"); subtext: Translation.tr("Join this network whenever it is in range")
            checked: page.autoconnect
            onToggled: v => { page.autoconnect = v; NxNmcli.setAutoconnect(page.ssid, v, null) }
        }
    }

    NxHeader { visible: page.ap !== null; text: Translation.tr("Signal") }
    NxGroup {
        visible: page.ap !== null
        NxInfoRow { icon: "signal_cellular_alt"; text: Translation.tr("Signal strength"); value: (page.ap ? page.ap.strength : 0) + "%" }
        NxInfoRow { icon: "lock"; text: Translation.tr("Security"); value: page.ap && page.ap.isSecure ? page.ap.security : Translation.tr("Open") }
        NxInfoRow {
            visible: page.ap !== null && NwUtil.band(page.ap.frequency).length > 0
            icon: "speed"; text: Translation.tr("Band"); value: page.ap ? NwUtil.band(page.ap.frequency) : ""
        }
        NxInfoRow { icon: "memory"; text: "BSSID"; value: page.ap ? page.ap.bssid : "" }
    }

    NxHeader { visible: page.active && !!page.det.ipAddress; text: Translation.tr("Connection") }
    NxGroup {
        visible: page.active && !!page.det.ipAddress
        NxInfoRow { icon: "pin"; text: Translation.tr("IP address"); value: page.det.ipAddress ?? "" }
        NxInfoRow { visible: !!page.det.subnet; icon: "grid_3x3"; text: Translation.tr("Subnet mask"); value: page.det.subnet ?? "" }
        NxInfoRow { visible: !!page.det.gateway; icon: "router"; text: Translation.tr("Gateway"); value: page.det.gateway ?? "" }
        NxInfoRow { visible: (page.det.dns ?? []).length > 0; icon: "dns"; text: "DNS"; value: (page.det.dns ?? []).join(", ") }
        NxInfoRow { visible: !!page.det.mac; icon: "memory"; text: Translation.tr("MAC address"); value: page.det.mac ?? "" }
    }

    NxHeader { visible: page.saved; text: Translation.tr("IP settings") }
    Loader {
        Layout.fillWidth: true
        active: page.saved
        visible: active
        sourceComponent: NwIpForm { connection: page.ssid }
    }

    NxGroup {
        visible: page.saved
        Layout.topMargin: 14
        NxInfoRow {
            visible: page.error.length > 0
            icon: "error"; text: page.error; value: ""
        }
        NxButtonRow {
            icon: "delete"
            text: page.confirmForget ? Translation.tr("Tap again to forget") : Translation.tr("Forget network")
            subtext: page.confirmForget ? "" : Translation.tr("Removes the saved profile and password")
            pill: page.confirmForget ? Translation.tr("Forget") : ""
            accent: page.confirmForget
            onClicked: {
                if (!page.confirmForget) { page.confirmForget = true; return; }
                NxNmcli.forget(page.ssid, r => {
                    if (r && r.success) NxNav.pop();
                    else page.error = Translation.tr("Could not forget the network");
                });
            }
        }
    }
}
