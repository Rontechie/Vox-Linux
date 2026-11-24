import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

ColumnLayout {
    id: root
    property string text: ""
    property string description: ""
    property var options: []
    property var currentValue: null
    property string tab: ""
    property var tags: []
    property string settingKey: ""
    signal selected(var newValue)

    Layout.fillWidth: true
    spacing: SettingsTheme.spacingS

    ColumnLayout {
        Layout.fillWidth: true
        Layout.leftMargin: SettingsTheme.spacingM
        Layout.rightMargin: SettingsTheme.spacingM
        Layout.topMargin: SettingsTheme.spacingS
        spacing: 2
        StyledText {
            text: root.text
            font.pixelSize: SettingsTheme.fontSizeMedium
            font.weight: Font.Medium
            color: SettingsTheme.surfaceText
        }
        StyledText {
            visible: root.description !== ""
            Layout.fillWidth: true
            text: root.description
            wrapMode: Text.WordWrap
            font.pixelSize: SettingsTheme.fontSizeSmall
            color: SettingsTheme.surfaceVariantText
        }
    }
    HSegmented {
        Layout.leftMargin: SettingsTheme.spacingM
        Layout.bottomMargin: SettingsTheme.spacingS
        options: root.options
        currentValue: root.currentValue
        onSelected: v => root.selected(v)
    }
}
