import qs.modules.common.widgets
import qs.modules.common
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RippleButton {
    id: root
    property string buttonIcon
    property alias iconSize: iconWidget.iconSize

    Layout.fillWidth: true
    implicitHeight: Math.max(48, contentItem.implicitHeight + SettingsTheme.spacingM * 2)
    font.pixelSize: SettingsTheme.fontSizeMedium
    buttonRadius: SettingsTheme.cornerRadius
    colBackgroundHover: SettingsTheme.withAlpha(SettingsTheme.primary, 0.07)
    colRipple: SettingsTheme.withAlpha(SettingsTheme.primary, 0.14)
    
    onClicked: checked = !checked

    contentItem: RowLayout {
        spacing: SettingsTheme.spacingM
        OptionalMaterialSymbol {
            id: iconWidget
            icon: root.buttonIcon
            opacity: root.enabled ? 1 : 0.4
            iconSize: Appearance.font.pixelSize.larger
        }
        StyledText {
            id: labelWidget
            Layout.fillWidth: true
            text: root.text
            font: root.font
            color: SettingsTheme.surfaceText
            opacity: root.enabled ? 1 : 0.4
        }
        StyledSwitch {
            id: switchWidget
            down: root.down
            Layout.fillWidth: false
            checked: root.checked
            onClicked: root.clicked()
        }
    }
}

