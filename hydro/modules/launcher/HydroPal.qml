import QtQuick
import qs.modules.common

QtObject {
    readonly property real lum: Appearance.m3colors.m3background.hslLightness
    readonly property bool dark: lum < 0.5
    readonly property color surface: Appearance.colors.colBackgroundSurfaceContainer
    readonly property color container: Appearance.colors.colSurfaceContainerHigh
    readonly property color containerHigh: Appearance.colors.colSurfaceContainerHighest
    readonly property color containerHighest: Appearance.colors.colSurfaceContainerHighestHover
    readonly property color primary: Appearance.colors.colPrimary
    readonly property color fgOnPrimary: Appearance.colors.colOnPrimary
    readonly property color primaryContainer: Appearance.colors.colPrimaryContainer
    readonly property color fgOnPrimaryContainer: Appearance.colors.colOnPrimaryContainer
    readonly property color fg: (lum < 0.5 ? Qt.rgba(1, 1, 1, 1) : Qt.rgba(0, 0, 0, 1))
    readonly property color onSurfaceVariant: (lum < 0.5 ? Qt.rgba(0.84, 0.84, 0.84, 1) : Qt.rgba(0.17, 0.17, 0.17, 1))
    readonly property color error: Appearance.m3colors.m3error
    readonly property color errorContainer: Appearance.m3colors.m3errorContainer

}
