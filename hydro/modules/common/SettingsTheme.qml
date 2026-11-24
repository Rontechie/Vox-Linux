pragma Singleton
import Quickshell
import QtQuick
import qs.modules.common

Singleton {
    readonly property int spacingXS: 4
    readonly property int spacingS: 8
    readonly property int spacingM: 12
    readonly property int spacingL: 16
    readonly property int spacingXL: 24
    readonly property int cornerRadius: Appearance.rounding.normal
    readonly property int iconSize: 22
    readonly property int shortDuration: 150

    readonly property int fontSizeSmall: Appearance.font.pixelSize.smaller
    readonly property int fontSizeMedium: Appearance.font.pixelSize.small
    readonly property int fontSizeLarge: Appearance.font.pixelSize.larger

    readonly property color surface: Appearance.colors.colLayer1
    readonly property color surfaceText: Appearance.colors.colOnLayer1
    readonly property color surfaceVariantText: Appearance.colors.colSubtext
    readonly property color primary: Appearance.colors.colPrimary
    readonly property color outline: Appearance.colors.colOutlineVariant

    function withAlpha(c, a) { return Qt.rgba(c.r, c.g, c.b, a) }
}
