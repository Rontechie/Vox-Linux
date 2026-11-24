import qs.modules.common
import QtQuick
import QtQuick.Controls

Switch {
    id: root
    implicitWidth: 52
    implicitHeight: 30
    padding: 0
    property color activeColor: Appearance.colors.colPrimary
    property color inactiveColor: Appearance.colors.colSurfaceContainerHighest
    readonly property bool grown: root.pressed || root.down
    readonly property real thumbSize: grown ? 26 : checked ? 22 : 14

    PointingHandInteraction {}

    background: Rectangle {
        radius: height / 2
        color: root.checked ? root.activeColor : root.inactiveColor
        border.width: 2
        border.color: root.checked ? root.activeColor : Appearance.m3colors.m3outline
        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }
    }

    indicator: Rectangle {
        readonly property real margin: (root.height - width) / 2
        width: root.thumbSize
        height: root.thumbSize
        radius: width / 2
        y: (root.height - height) / 2
        x: root.checked ? root.width - width - margin : margin
        color: root.checked ? Appearance.m3colors.m3onPrimary : Appearance.m3colors.m3outline

        Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
        Behavior on height { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: 150 } }

        MaterialSymbol {
            anchors.centerIn: parent
            text: "check"
            iconSize: 16
            color: root.activeColor
            opacity: root.checked ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 120 } }
        }
    }
}
