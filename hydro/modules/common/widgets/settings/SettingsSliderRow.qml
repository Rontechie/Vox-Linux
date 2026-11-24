import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    property string text: ""
    property string description: ""
    property real value: 0
    property real from: 0
    property real to: 100
    property real stepSize: 1
    property string unit: ""
    property int decimals: 0
    property string tab: ""
    property var tags: []
    property string settingKey: ""
    signal sliderValueChanged(real newValue)

    Layout.fillWidth: true
    implicitHeight: column.implicitHeight + SettingsTheme.spacingM * 2

    ColumnLayout {
        id: column
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: SettingsTheme.spacingM
            rightMargin: SettingsTheme.spacingM
        }
        spacing: SettingsTheme.spacingXS

        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
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
            StyledText {
                text: root.value.toFixed(root.decimals) + root.unit
                font.pixelSize: SettingsTheme.fontSizeMedium
                font.family: Appearance.font.family.monospace
                color: SettingsTheme.primary
            }
        }

        DankSliderControl {
            id: slider
            Layout.fillWidth: true
            from: root.from
            to: root.to
            stepSize: root.stepSize
            value: root.value
            usePercentTooltip: false
            unit: root.unit
            onMoved: root.sliderValueChanged(slider.value)
        }
    }
}
