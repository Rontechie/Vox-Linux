import QtQuick
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Row {
    id: root
    signal triggered(string action)
    property bool interactive: true
    spacing: 14

    Repeater {
        model: [
            { icon: "bedtime", label: Translation.tr("Sleep"), action: "sleep" },
            { icon: "restart_alt", label: Translation.tr("Restart"), action: "reboot" },
            { icon: "power_settings_new", label: Translation.tr("Shut down"), action: "poweroff" }
        ]
        delegate: Rectangle {
            id: pb
            required property var modelData
            width: 52
            height: 52
            radius: pbArea.pressed ? 14 : 26
            color: pbHover.hovered ? Qt.rgba(1, 1, 1, 0.22) : Qt.rgba(1, 1, 1, 0.12)
            Behavior on radius { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 120 } }
            MaterialSymbol { anchors.centerIn: parent; text: pb.modelData.icon; iconSize: 24; color: "white" }
            HoverHandler { id: pbHover }
            MouseArea {
                id: pbArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                enabled: root.interactive
                onClicked: root.triggered(pb.modelData.action)
            }
            Rectangle { // label on hover
                visible: pbHover.hovered
                anchors.bottom: parent.top
                anchors.bottomMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                implicitWidth: tip.implicitWidth + 16
                implicitHeight: 26
                radius: 13
                color: Qt.rgba(0, 0, 0, 0.7)
                StyledText { id: tip; anchors.centerIn: parent; text: pb.modelData.label; font.pixelSize: Appearance.font.pixelSize.smaller; color: "white" }
            }
        }
    }
}
