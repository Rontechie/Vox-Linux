pragma Singleton
import QtQuick
import Quickshell
import qs.modules.common

Singleton {
    readonly property real gridCell: 20 // fixed: widget sizes are rounded to it
    readonly property real snapCell: HwConfig.general.snapToGrid ? Math.max(1, HwConfig.general.gridSize) : 1
    readonly property real widgetGap: 0
    readonly property real animScale: 1
    readonly property real widgetBoxX: 0
    readonly property real widgetBoxY: 0
    readonly property real animBoxX: 0
    readonly property real animBoxY: 0
    readonly property bool resizingEdge: false

    readonly property string barEdge: Config.options.bar.bottom ? "bottom" : "top"
    readonly property bool islandMode: false
    readonly property real topBaseH: Appearance.sizes.barHeight
    readonly property real islandAutoHideRevealFactor: Config.options.bar.autoHide.enable ? 0 : 1
    readonly property real islandRestHalfWidth: 0

    function menu_openFor(item, type) {}
}
