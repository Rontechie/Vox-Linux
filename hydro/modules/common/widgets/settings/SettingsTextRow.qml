import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    property string text: ""
    property string description: ""
    property string value: ""
    property string placeholderText: ""
    property bool monospace: false
    property string tab: ""
    property var tags: []
    property string settingKey: ""
    signal valueCommitted(string newValue)

    Layout.fillWidth: true
    implicitHeight: Math.max(56, labels.implicitHeight + SettingsTheme.spacingM * 2)

    RowLayout {
        anchors {
            fill: parent
            leftMargin: SettingsTheme.spacingM
            rightMargin: SettingsTheme.spacingM
        }
        spacing: SettingsTheme.spacingM

        ColumnLayout {
            id: labels
            Layout.fillWidth: true
            spacing: 2
            StyledText {
                text: root.text
                font.pixelSize: SettingsTheme.fontSizeMedium
                font.weight: Font.Medium
                color: SettingsTheme.surfaceText
                Layout.fillWidth: true
            }
            StyledText {
                visible: root.description !== ""
                text: root.description
                font.pixelSize: SettingsTheme.fontSizeSmall
                color: SettingsTheme.surfaceVariantText
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
        }

        Rectangle {
            Layout.preferredWidth: 210
            implicitHeight: 40
            radius: SettingsTheme.cornerRadius
            color: Appearance.colors.colLayer2
            border.width: input.activeFocus ? 2 : 0
            border.color: SettingsTheme.primary

            TextInput {
                id: input
                anchors {
                    fill: parent
                    leftMargin: SettingsTheme.spacingM
                    rightMargin: SettingsTheme.spacingM
                }
                verticalAlignment: TextInput.AlignVCenter
                text: root.value
                color: SettingsTheme.surfaceText
                selectionColor: SettingsTheme.primary
                font.family: root.monospace ? Appearance.font.family.monospace : Appearance.font.family.main
                font.pixelSize: SettingsTheme.fontSizeMedium
                selectByMouse: true
                clip: true
                onEditingFinished: if (text !== root.value) root.valueCommitted(text)
            }
            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: SettingsTheme.spacingM
                visible: input.text === "" && !input.activeFocus
                text: root.placeholderText
                font.pixelSize: SettingsTheme.fontSizeMedium
                color: SettingsTheme.surfaceVariantText
            }
        }
    }
}
