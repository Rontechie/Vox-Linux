pragma Singleton

import QtQuick
import Quickshell
import qs.modules.common

Singleton {
    id: root

    readonly property bool light: !Appearance.m3colors.darkmode
    readonly property QtObject palette: Appearance.m3colors

    readonly property QtObject transparency: QtObject {
        readonly property bool enabled: false
        readonly property real base: 0.85
        readonly property real layers: 0.4
    }

    readonly property QtObject tPalette: QtObject {
        readonly property real a: root.transparency.enabled ? root.transparency.base : 1
        readonly property color m3surface: Qt.alpha(Appearance.m3colors.m3surface, a)
        readonly property color m3surfaceContainerLowest: Qt.alpha(Appearance.m3colors.m3surfaceContainerLowest, a)
        readonly property color m3surfaceContainerLow: Qt.alpha(Appearance.m3colors.m3surfaceContainerLow, a)
        readonly property color m3surfaceContainer: Qt.alpha(Appearance.m3colors.m3surfaceContainer, a)
        readonly property color m3surfaceContainerHigh: Qt.alpha(Appearance.m3colors.m3surfaceContainerHigh, a)
        readonly property color m3surfaceContainerHighest: Qt.alpha(Appearance.m3colors.m3surfaceContainerHighest, a)
    }

    function layer(c: color, layer: var): color {
        if (!transparency.enabled)
            return c;
        return Qt.alpha(c, layer === 0 ? transparency.base : Math.max(0, 1 - transparency.layers * (layer ?? 1)));
    }

    function on(c: color): color {
        return c.hslLightness < 0.5 ? Appearance.m3colors.m3onSurface : Appearance.m3colors.m3surface;
    }

    function setMode(mode: string): void {
        Quickshell.execDetached(["bash", Directories.wallpaperSwitchScriptPath, "--mode", mode === "light" ? "light" : "dark", "--noswitch"]);
    }
}
