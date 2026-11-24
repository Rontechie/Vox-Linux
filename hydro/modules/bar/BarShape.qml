import QtQuick
import QtQuick.Shapes
import qs.modules.common

Item {
    id: root
    property color fillColor: "#000000"
    property real topLeft: 0
    property real topRight: 0
    property real bottomLeft: 0
    property real bottomRight: 0
    property bool concaveTop: false    // carve the two top corners instead of rounding them
    property bool concaveBottom: false // same for the two bottom corners
    property color borderColor: "transparent"
    property real borderWidth: 0

    readonly property real bw: Math.max(0, borderWidth)
    readonly property real w: Math.max(0, width - bw)
    readonly property real h: Math.max(0, height - bw)

    function r(v) { return Math.max(0, Math.min(v, Math.min(w, h) / 2)); }
    function arc(rad, sweep, x, y) { return rad > 0 ? ` A ${rad} ${rad} 0 0 ${sweep} ${x} ${y}` : ` L ${x} ${y}`; }

    readonly property string d: {
        const tl = r(topLeft), tr = r(topRight), br = r(bottomRight), bl = r(bottomLeft);
        const st = concaveTop ? 0 : 1, sb = concaveBottom ? 0 : 1;
        return `M ${tl} 0 L ${w - tr} 0` + arc(tr, st, w, tr)
             + ` L ${w} ${h - br}` + arc(br, sb, w - br, h)
             + ` L ${bl} ${h}` + arc(bl, sb, 0, h - bl)
             + ` L 0 ${tl}` + arc(tl, st, tl, 0) + " Z";
    }

    Shape {
        x: root.bw / 2
        y: root.bw / 2
        width: root.w
        height: root.h
        layer.enabled: true
        layer.samples: 4
        ShapePath {
            fillColor: root.fillColor
            strokeColor: root.bw > 0 ? root.borderColor : "transparent"
            strokeWidth: root.bw > 0 ? root.bw : -1
            PathSvg { path: root.d }
        }
    }
}
