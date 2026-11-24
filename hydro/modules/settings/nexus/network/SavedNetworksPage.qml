import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    Component.onCompleted: NxNmcli.loadSaved(null)

    NxHeader { text: Translation.tr("Saved networks") }
    NxGroup {
        Repeater {
            model: NxNmcli.savedWifi
            delegate: NxNavRow {
                id: saved
                required property var modelData
                readonly property var ap: Network.wifiNetworks.find(n => n.ssid === modelData.ssid) ?? null
                icon: ap ? NwUtil.wifiIcon(ap.strength, ap.isSecure) : "wifi"
                text: modelData.name
                subtext: ap ? (ap.active ? Translation.tr("Connected") : Translation.tr("In range")) : Translation.tr("Out of range")
                trailingIcon: "chevron_right"
                onClicked: NxNav.push(modelData.name, "modules/settings/nexus/network/NetworkDetailPage.qml", { ssid: modelData.ssid })
            }
        }
        NxInfoRow {
            visible: NxNmcli.savedWifi.length === 0
            icon: "bookmark_border"; text: Translation.tr("No saved networks"); value: ""
        }
    }
    StyledText {
        visible: NxNmcli.savedWifi.length > 0
        Layout.fillWidth: true; Layout.topMargin: 8; Layout.leftMargin: 8
        wrapMode: Text.WordWrap
        text: Translation.tr("Open a network to change its settings or forget it.")
        font.pixelSize: Appearance.font.pixelSize.smaller
        color: Appearance.m3colors.m3outline
    }
}
