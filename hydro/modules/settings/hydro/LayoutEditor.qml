import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.widgets.settings

ColumnLayout {
    id: root
    property string title: ""
    property var current: []
    signal edited(var list)

    readonly property var allWidgets: ["logo", "windowTitle", "workspaces", "tray", "status", "clock", "launcher", "leftSidebar", "activeWindow", "media", "resources", "cpu", "ram", "network", "battery", "notifications", "weather", "utilButtons"]
    readonly property var available: allWidgets.filter(w => Array.from(current).indexOf(w) < 0)

    function move(i, d) {
        const l = Array.from(current);
        const j = i + d;
        if (j < 0 || j >= l.length) return;
        const t = l[i]; l[i] = l[j]; l[j] = t;
        edited(l);
    }
    function removeAt(i) {
        const l = Array.from(current);
        l.splice(i, 1);
        edited(l);
    }
    function add(w) {
        const l = Array.from(current);
        l.push(w);
        edited(l);
    }

    Layout.fillWidth: true
    Layout.leftMargin: SettingsTheme.spacingM
    Layout.rightMargin: SettingsTheme.spacingM
    spacing: 8

    StyledText {
        text: root.title
        font.weight: Font.Medium
        color: SettingsTheme.surfaceText
    }

    Flow {
        Layout.fillWidth: true
        spacing: 6
        Repeater {
            model: root.current
            delegate: Rectangle {
                id: chip
                required property int index
                required property string modelData
                height: 32
                width: chipRow.implicitWidth + 16
                radius: height / 2
                color: Appearance.colors.colSecondaryContainer
                Row {
                    id: chipRow
                    anchors.centerIn: parent
                    spacing: 6
                    StyledText { anchors.verticalCenter: parent.verticalCenter; text: chip.modelData; color: Appearance.m3colors.m3onSecondaryContainer }
                    MaterialSymbol {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "chevron_left"; iconSize: 18; color: Appearance.m3colors.m3onSecondaryContainer
                        opacity: chip.index > 0 ? 1 : 0.3
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.move(chip.index, -1) }
                    }
                    MaterialSymbol {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "chevron_right"; iconSize: 18; color: Appearance.m3colors.m3onSecondaryContainer
                        opacity: chip.index < root.current.length - 1 ? 1 : 0.3
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.move(chip.index, 1) }
                    }
                    MaterialSymbol {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "close"; iconSize: 18; color: Appearance.m3colors.m3onSecondaryContainer
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.removeAt(chip.index) }
                    }
                }
            }
        }
    }

    Flow {
        Layout.fillWidth: true
        spacing: 6
        Repeater {
            model: root.available
            delegate: Rectangle {
                id: addChip
                required property string modelData
                height: 28
                width: addRow.implicitWidth + 16
                radius: height / 2
                color: "transparent"
                border.width: 1
                border.color: Appearance.colors.colOutlineVariant
                Row {
                    id: addRow
                    anchors.centerIn: parent
                    spacing: 4
                    MaterialSymbol { anchors.verticalCenter: parent.verticalCenter; text: "add"; iconSize: 16; color: Appearance.colors.colSubtext }
                    StyledText { anchors.verticalCenter: parent.verticalCenter; text: addChip.modelData; color: Appearance.colors.colSubtext; font.pixelSize: Appearance.font.pixelSize.smaller }
                }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.add(addChip.modelData) }
            }
        }
    }
}
