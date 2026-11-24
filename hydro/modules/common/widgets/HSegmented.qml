import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    property var options: []
    property var currentValue: null
    signal selected(var newValue)

    readonly property int currentIndex: {
        for (let i = 0; i < options.length; i++)
            if (options[i].value == currentValue) return i
        return -1
    }

    implicitHeight: 44
    implicitWidth: row.implicitWidth + 8

    Rectangle {
        anchors.fill: parent
        radius: SettingsTheme.cornerRadius
        color: Appearance.colors.colLayer2
        border.width: 1
        border.color: SettingsTheme.withAlpha(SettingsTheme.outline, 0.5)
    }

    Rectangle { // sliding indicator
        id: thumb
        readonly property Item target: root.currentIndex >= 0 ? repeater.itemAt(root.currentIndex) : null
        visible: target !== null
        y: 4
        height: parent.height - 8
        x: target ? row.x + target.x : 4
        width: target ? target.width : 0
        radius: SettingsTheme.cornerRadius - 3
        color: Appearance.colors.colPrimary
        Behavior on x { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
    }

    Row {
        id: row
        x: 4
        y: 4
        height: parent.height - 8
        spacing: 0

        Repeater {
            id: repeater
            model: root.options

            delegate: Item {
                id: seg
                required property var modelData
                required property int index
                readonly property bool on: root.currentIndex === index

                width: content.implicitWidth + 32
                height: row.height

                Rectangle {
                    anchors.fill: parent
                    radius: SettingsTheme.cornerRadius - 3
                    color: SettingsTheme.withAlpha(Appearance.colors.colOnLayer1, 0.07)
                    visible: area.containsMouse && !seg.on
                }
                Row {
                    id: content
                    anchors.centerIn: parent
                    spacing: 6
                    MaterialSymbol {
                        visible: !!seg.modelData.icon
                        anchors.verticalCenter: parent.verticalCenter
                        text: seg.modelData.icon || ""
                        iconSize: 18
                        color: seg.on ? Appearance.colors.colOnPrimary : Appearance.colors.colSubtext
                    }
                    StyledText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: seg.modelData.displayName
                        font.pixelSize: SettingsTheme.fontSizeMedium
                        font.weight: seg.on ? Font.Medium : Font.Normal
                        color: seg.on ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
                    }
                }
                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.selected(seg.modelData.value)
                }
            }
        }
    }
}
