pragma Singleton
import QtQuick
import Quickshell
import qs.modules.common

Singleton {
    readonly property color black: "#000000"
    readonly property color panel: "#0A0A0A"
    readonly property color panelHover: "#151515"
    readonly property color line: "#2B2B2B"
    readonly property color lineStrong: "#6E6E6E"
    readonly property color white: "#FFFFFF"
    readonly property color sub: "#8A8A8A"
    readonly property color red: "#D71921"

    readonly property string mono: Appearance.font.family.monospace
    readonly property string dot: Qt.fontFamilies().indexOf("Doto") >= 0 ? "Doto"
        : Qt.fontFamilies().indexOf("Ndot57") >= 0 ? "Ndot57"
        : Qt.fontFamilies().indexOf("Ndot 57") >= 0 ? "Ndot 57" : Appearance.font.family.monospace
}
