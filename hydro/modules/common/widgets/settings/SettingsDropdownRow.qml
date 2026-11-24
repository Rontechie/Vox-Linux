import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    property string text: ""
    property string description: ""
    property var options: []
    property var values: []
    property var currentValue: undefined
    property string tab: ""
    property var tags: []
    property string settingKey: ""
    signal valueChanged(var value)

    readonly property var keys: values.length > 0 ? values : options

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
        StyledComboBox {
            Layout.fillWidth: false
            Layout.preferredWidth: 210
            buttonRadius: Appearance.rounding.small
            model: root.options
            currentIndex: Math.max(0, root.keys.indexOf(root.currentValue))
            onActivated: index => root.valueChanged(root.keys[index])
        }
    }
}
