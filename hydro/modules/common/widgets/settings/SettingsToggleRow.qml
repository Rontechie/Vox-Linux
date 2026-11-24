import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    property string text: ""
    property string description: ""
    property bool checked: false
    property string tab: ""
    property var tags: []
    property string settingKey: ""
    signal toggled(bool checked)

    Layout.fillWidth: true
    implicitHeight: Math.max(48, labels.implicitHeight + SettingsTheme.spacingM * 2)

    Rectangle {
        anchors.fill: parent
        radius: SettingsTheme.cornerRadius
        color: SettingsTheme.withAlpha(SettingsTheme.primary, hover.hovered ? 0.06 : 0)
        Behavior on color { ColorAnimation { duration: SettingsTheme.shortDuration } }
    }
    HoverHandler { id: hover }
    TapHandler { onTapped: sw.toggle() }

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
                wrapMode: Text.WordWrap
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
        StyledSwitch {
            id: sw
            checked: root.checked
            onToggled: {
                root.toggled(sw.checked)
                sw.checked = Qt.binding(() => root.checked) // keep following the config value
            }
        }
    }
}
