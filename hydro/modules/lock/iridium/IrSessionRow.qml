import QtQuick
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    signal triggered(string key)

    implicitHeight: 40
    implicitWidth: row.implicitWidth + 12
    radius: height / 2
    color: Appearance.colors.colSecondaryContainer

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4
        Repeater {
            model: [
                { key: "sleep", icon: "bedtime", label: Translation.tr("Sleep"), danger: false },
                { key: "restart", icon: "restart_alt", label: Translation.tr("Restart"), danger: true },
                { key: "shutdown", icon: "power_settings_new", label: Translation.tr("Shut down"), danger: true }
            ]
            delegate: Rectangle {
                id: btn
                required property var modelData
                implicitHeight: 32
                implicitWidth: content.implicitWidth + 22
                radius: area.pressed ? 10 : height / 2
                Behavior on radius { NumberAnimation { duration: 140 } }
                color: modelData.danger ? Qt.rgba(Appearance.m3colors.m3error.r, Appearance.m3colors.m3error.g, Appearance.m3colors.m3error.b, area.containsMouse ? 0.34 : 0.2)
                                        : Qt.rgba(1, 1, 1, area.containsMouse ? 0.2 : 0.1)
                Behavior on color { ColorAnimation { duration: 120 } }
                Row {
                    id: content
                    anchors.centerIn: parent
                    spacing: 6
                    MaterialSymbol {
                        anchors.verticalCenter: parent.verticalCenter
                        text: btn.modelData.icon
                        iconSize: 16
                        color: btn.modelData.danger ? Appearance.m3colors.m3error : Appearance.colors.colOnSecondaryContainer
                    }
                    StyledText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: btn.modelData.label
                        font.pixelSize: Appearance.font.pixelSize.smaller
                        color: Appearance.colors.colOnSecondaryContainer
                    }
                }
                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.triggered(btn.modelData.key)
                }
            }
        }
    }
}
