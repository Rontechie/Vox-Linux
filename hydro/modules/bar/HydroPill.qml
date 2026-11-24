import QtQuick
import QtQuick.Layouts
import qs.modules.common

Rectangle {
    id: root
    property color baseColor: Appearance.capsuleFill
    property color hoverColor: Appearance.capsuleCustom ? Qt.tint(Appearance.capsuleFill, "#2effffff") : "#33ffffff"
    readonly property real widgetScale: Config.options.bar.sizes.widgetScale
    property real hPadding: 12 * widgetScale
    property real spacing: 8
    property bool clickable: true
    property bool emphasized: false // keeps its fill even when capsules are switched off
    readonly property var caps: Config.options.bar.capsules
    default property alias content: row.data
    readonly property bool hovered: mouse.containsMouse
    signal clicked()

    implicitWidth: row.implicitWidth + hPadding * 2
    implicitHeight: Math.min(Appearance.sizes.baseBarHeight, Math.round(Appearance.sizes.baseBarHeight * caps.thickness * widgetScale))
    radius: caps.radiusAuto ? height / 2 * Math.min(1, Appearance.rScale) : Math.min(caps.radius, height / 2)
    readonly property bool inIsland: Config.options.bar.islands.enable
    color: (hovered && clickable) ? hoverColor : (((caps.enable && !inIsland) || emphasized) ? baseColor : "transparent")
    scale: (mouse.pressed && clickable) ? 0.92 : (hovered && clickable ? 1.05 : 1)

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on scale { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
    Behavior on implicitWidth { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: root.spacing
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.clickable
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
