pragma Singleton
import QtQuick
import Quickshell
import qs.modules.common

Singleton {
    id: root
    readonly property var c: Appearance.m3colors

    readonly property color primary: c.m3primary
    readonly property color primaryContainer: c.m3primaryContainer
    readonly property color inkPrimaryContainer: c.m3onPrimaryContainer
    readonly property color secondaryContainer: c.m3secondaryContainer
    readonly property color inkSecondaryContainer: c.m3onSecondaryContainer
    readonly property color error: c.m3error
    readonly property color inkSurface: c.m3onSurface
    readonly property color surfaceContainer: c.m3surfaceContainer

    readonly property color ringActive: primary
    readonly property color ringTrack: alpha(c.m3onSurface, 0.14)
    readonly property real progressThickness: 1.0
    readonly property int durFast: 150

    readonly property var springCurve: Appearance.animationCurves.expressiveDefaultSpatial
    readonly property var springCurveFast: Appearance.animationCurves.expressiveFastSpatial
    readonly property var standardCurve: [0.2, 0, 0, 1, 1, 1]

    function ringLw(w) { return w * progressThickness; }
    function alpha(col, a) { return Qt.rgba(col.r, col.g, col.b, a); }
    function css(col) {
        return "rgba(" + Math.round(col.r * 255) + "," + Math.round(col.g * 255) + "," + Math.round(col.b * 255) + "," + col.a + ")";
    }
}
