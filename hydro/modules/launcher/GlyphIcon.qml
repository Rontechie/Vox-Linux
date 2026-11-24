import QtQuick
import QtQuick.Shapes
import "Glyphs.js" as G

Item {
    id: gi
    property string glyph
    property color color: "white"
    implicitWidth: 24; implicitHeight: 24
    Shape {
        width: 24; height: 24
        readonly property real k: Math.min(gi.width, gi.height) / 24
        scale: k
        transformOrigin: Item.TopLeft
        x: (gi.width - 24 * k) / 2; y: (gi.height - 24 * k) / 2
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            fillColor: gi.color; strokeColor: "transparent"; strokeWidth: 0
            fillRule: ShapePath.WindingFill
            PathSvg { path: G.get(gi.glyph) }
        }
    }
}
