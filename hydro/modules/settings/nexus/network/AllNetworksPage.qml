import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    Component.onCompleted: NxNmcli.loadSaved(null)

    NxGroup {
        NxButtonRow {
            icon: "refresh"; text: Translation.tr("Scan for networks")
            busy: Network.wifiScanning; disabled: Network.wifiScanning || !Network.wifiEnabled
            onClicked: Network.rescanWifi()
        }
    }
    NxHeader { text: Translation.tr("%1 networks").arg(Network.friendlyWifiNetworks.length) }
    Repeater {
        model: Network.wifiEnabled ? Network.friendlyWifiNetworks : []
        delegate: NwNetworkItem {
            required property var modelData
            ap: modelData
        }
    }
    StyledText {
        visible: !Network.wifiEnabled || Network.friendlyWifiNetworks.length === 0
        Layout.fillWidth: true; Layout.topMargin: 12
        horizontalAlignment: Text.AlignHCenter
        text: Network.wifiEnabled ? Translation.tr("No networks found") : Translation.tr("Wi-Fi is off")
        color: Appearance.m3colors.m3outline
    }
}
