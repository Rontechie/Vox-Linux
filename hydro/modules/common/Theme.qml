pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property color bg: "#d90f1218"      // translucent night slate
    readonly property color fg: "#d8dee9"
    readonly property color dim: "#4c566a"
    readonly property color accent: "#9fb4d6"    // wolf-fur ice blue
    readonly property color warn: "#e0a3a3"      // low battery, muted

    readonly property string font: "Inter"
    readonly property string mono: "JetBrains Mono NF"
    readonly property int fontSize: 13

    readonly property int radius: 10
    readonly property int barHeight: 36
    readonly property int barGap: 6               // gap between bar and screen edge
    readonly property int spacing: 8
}
