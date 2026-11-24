pragma Singleton
import QtQuick
import Quickshell
import qs.modules.common

Singleton {
    readonly property color primary: Appearance.m3colors.m3primary
    readonly property color colorOnSurface: Appearance.m3colors.m3onSurface
    readonly property color muted: Appearance.m3colors.m3outline
}
