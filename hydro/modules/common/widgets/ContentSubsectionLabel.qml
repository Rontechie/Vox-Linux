import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

StyledText {
    text: "Subsection"
    color: SettingsTheme.surfaceVariantText
    font.family: Appearance.font.family.monospace
    font.pixelSize: Appearance.font.pixelSize.smallest + 1
    font.capitalization: Font.AllUppercase
    font.letterSpacing: 1.5
    Layout.leftMargin: SettingsTheme.spacingM
    Layout.topMargin: SettingsTheme.spacingXS
}
