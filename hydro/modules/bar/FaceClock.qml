import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common
import qs.modules.bar.faces

HydroPill {
    id: root
    property string face: "classic"
    baseColor: FacePal.dark ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(0, 0, 0, 0.10)
    hoverColor: FacePal.dark ? Qt.rgba(1, 1, 1, 0.26) : Qt.rgba(0, 0, 0, 0.18)
    emphasized: true // keep the fill even with capsules off
    onClicked: GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen

    readonly property string orientation: "horizontal"
    readonly property bool isCompact: false
    readonly property var barWindow: null
    readonly property bool moduleActive: true
    readonly property bool showDate: Config.options.bar.verbose
    function s(v) { return Math.round(v * Config.options.bar.sizes.fontScale); }

    readonly property var d: DateTime.clock.date
    readonly property string timeStr: DateTime.time
    readonly property string hourStr: Qt.locale().toString(d, "hh")
    readonly property string minuteStr: Qt.locale().toString(d, "mm")
    readonly property string secondStr: Qt.locale().toString(d, "ss")
    readonly property string dayStr: Qt.locale().toString(d, "d")
    readonly property string monthStr: Qt.locale().toString(d, "MMM")
    readonly property string fullDateStr: Qt.locale().toString(d, "ddd, MMM d")
    property int typeIn: 0
    readonly property string dateStr: fullDateStr.substring(0, typeIn)
    Timer { // the date types itself in when it changes
        interval: 30
        repeat: true
        running: root.typeIn < root.fullDateStr.length
        onTriggered: root.typeIn += 1
    }
    onFullDateStrChanged: if (typeIn > fullDateStr.length) typeIn = fullDateStr.length

    Loader {
        id: loader
        Layout.alignment: Qt.AlignVCenter
        source: Qt.resolvedUrl("faces/" + ({ classic: "ClassicFace", badge: "BadgeFace", material: "MaterialFace" })[root.face] + ".qml")
        onLoaded: item.widget = root
    }
}
