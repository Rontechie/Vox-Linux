pragma Singleton
import QtQuick
import Quickshell
import qs.modules.common

Singleton {
    readonly property string fontFamily: Appearance.font.family.main
    readonly property real elementOpacity: 1
    readonly property real lum: Appearance.m3colors.m3background.hslLightness
    readonly property bool dark: lum < 0.5
    readonly property color text: dark ? Qt.rgba(1, 1, 1, 1) : Qt.rgba(0, 0, 0, 1)
    readonly property color subtext0: dark ? Qt.rgba(0.78, 0.78, 0.78, 1) : Qt.rgba(0.25, 0.25, 0.25, 1)
    readonly property color overlay0: dark ? Qt.rgba(0.6, 0.6, 0.6, 1) : Qt.rgba(0.4, 0.4, 0.4, 1)
    readonly property color surface0: Appearance.colors.colSurfaceContainerHigh
    readonly property color surface1: Appearance.colors.colSurfaceContainerHighest
    readonly property color surface2: Appearance.m3colors.m3outlineVariant
    readonly property color crust: Appearance.m3colors.m3surfaceContainerLowest
    readonly property color primary: Appearance.colors.colPrimary
    readonly property color mauve: Appearance.colors.colPrimary
    readonly property color blue: Appearance.colors.colPrimary
    readonly property color sapphire: Appearance.colors.colSecondary
    readonly property color teal: Appearance.colors.colTertiary
    readonly property color peach: Appearance.colors.colTertiary
}
