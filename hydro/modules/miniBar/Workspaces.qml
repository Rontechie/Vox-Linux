import Quickshell.Hyprland
import QtQuick
import qs.modules.common

Row {
    spacing: 6

    Repeater {
        model: 6

        Rectangle {
            required property int index
            readonly property int wsId: index + 1
            readonly property bool active: Hyprland.focusedWorkspace?.id === wsId
            readonly property bool occupied: Hyprland.workspaces.values.some(w => w.id === wsId)

            anchors.verticalCenter: parent.verticalCenter
            height: 10
            width: active ? 26 : 10
            radius: height / 2
            color: active ? Theme.accent : (occupied ? Theme.fg : Theme.dim)
            opacity: active || occupied ? 1 : 0.6

            Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 180 } }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                onClicked: Hyprland.dispatch("workspace " + parent.wsId)
            }
        }
    }
}
