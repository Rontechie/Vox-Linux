import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxGroup {
    id: item
    property var ap: null
    property bool showDetails: true
    readonly property bool saved: ap ? NxNmcli.hasSaved(ap.ssid) : false

    NxButtonRow {
        icon: item.ap ? NwUtil.wifiIcon(item.ap.strength, item.ap.isSecure) : "wifi"
        text: item.ap ? item.ap.ssid : ""
        subtext: item.ap ? ((item.ap.active ? Translation.tr("Connected") + " · " : item.saved ? Translation.tr("Saved") + " · " : "")
                 + (item.ap.isSecure ? item.ap.security : Translation.tr("Open"))
                 + (NwUtil.band(item.ap.frequency).length > 0 ? " · " + NwUtil.band(item.ap.frequency) : "")) : ""
        pill: item.ap && !item.ap.active ? Translation.tr("Connect") : Translation.tr("Disconnect")
        busy: item.ap !== null && Network.wifiConnecting && Network.wifiConnectTarget === item.ap
        onClicked: item.ap.active ? Network.disconnectWifiNetwork() : Network.connectToWifiNetwork(item.ap)
    }
    NwPasswordRow {
        visible: item.ap !== null && item.ap.askingPassword
        text: item.ap ? Translation.tr("Password for %1").arg(item.ap.ssid) : ""
        placeholder: Translation.tr("Enter password, press Enter")
        onAccepted: v => { if (v.length > 0 && item.ap) Network.changePassword(item.ap, v) }
    }
    NxNavRow {
        visible: item.showDetails && item.ap !== null && (item.ap.active || item.saved)
        icon: "info"; text: Translation.tr("Network details")
        onClicked: NxNav.push(item.ap.ssid, "modules/settings/nexus/network/NetworkDetailPage.qml", { ssid: item.ap.ssid })
    }
}
