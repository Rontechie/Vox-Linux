import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.widgets

NxPage {
    id: page

    NxHeader { text: "Wi-Fi" }
    NxGroup {
        NxToggleRow {
            icon: "wifi"; text: "Wi-Fi"
            subtext: Network.wifiEnabled ? (Network.active ? Translation.tr("Connected to %1").arg(Network.active.ssid) : Translation.tr("On")) : Translation.tr("Off")
            checked: Network.wifiEnabled
            onToggled: v => Network.enableWifi(v)
        }
        NxButtonRow {
            visible: Network.wifiEnabled
            icon: "refresh"; text: Translation.tr("Scan for networks")
            busy: Network.wifiScanning; disabled: Network.wifiScanning
            onClicked: Network.rescanWifi()
        }
        NxButtonRow {
            visible: Network.wifiEnabled && Network.active !== null
            icon: "wifi_off"; text: Translation.tr("Disconnect"); subtext: Network.active?.ssid ?? ""
            onClicked: Network.disconnectWifiNetwork()
        }
    }

    NxHeader { visible: Network.wifiEnabled; text: Translation.tr("Available networks") }
    Repeater {
        model: Network.wifiEnabled ? Network.friendlyWifiNetworks : []
        delegate: NxGroup {
            id: netGroup
            required property var modelData
            readonly property var ap: modelData
            NxButtonRow {
                icon: ap.strength > 75 ? "signal_wifi_4_bar" : ap.strength > 50 ? "network_wifi_3_bar" : ap.strength > 25 ? "network_wifi_2_bar" : "network_wifi_1_bar"
                text: ap.ssid
                subtext: (ap.active ? Translation.tr("Connected") + " · " : "") + (ap.isSecure ? ap.security : Translation.tr("Open"))
                pill: ap.active ? "" : Translation.tr("Connect")
                busy: Network.wifiConnecting && Network.wifiConnectTarget === ap
                onClicked: ap.active ? Network.disconnectWifiNetwork() : Network.connectToWifiNetwork(ap)
            }
            NxTextRow {
                visible: ap.askingPassword
                wide: true
                icon: "key"; text: Translation.tr("Password for %1").arg(ap.ssid)
                placeholder: Translation.tr("Enter password, press Enter")
                onEdited: v => { if (v.length > 0) Network.changePassword(ap, v) }
            }
        }
    }
    StyledText {
        visible: Network.wifiEnabled && Network.friendlyWifiNetworks.length === 0
        Layout.fillWidth: true; Layout.topMargin: 12
        horizontalAlignment: Text.AlignHCenter
        text: Translation.tr("No networks found")
        color: Appearance.m3colors.m3outline
    }

    NxHeader { text: Translation.tr("More") }
    NxGroup {
        NxInfoRow { icon: "lan"; text: "Ethernet"; value: Network.ethernet ? Translation.tr("Connected") : Translation.tr("Not connected") }
        NxButtonRow {
            icon: "settings_ethernet"; text: Translation.tr("Advanced network settings"); subtext: Translation.tr("Opens your network manager")
            onClicked: Quickshell.execDetached(["bash", "-c", Config.options.apps.network])
        }
    }
}
