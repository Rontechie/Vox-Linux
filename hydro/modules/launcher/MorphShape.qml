import QtQuick
import QtQuick.Shapes
import "ShapeLib.js" as Lib

Item {
    id: ms
    property string shape: "circle"
    property color color: "white"
    property bool spin: false
    property int spinPeriod: 14000
    property int duration: 560

    property var radii: Lib.get("circle")
    property var fromR: radii
    property var toR: radii
    property real t: 1
    Behavior on color { ColorAnimation { duration: 250 } }

    Component.onCompleted: { radii = Lib.get(shape); fromR = radii; toR = radii; if (spin) startSpin() }
    onShapeChanged: { fromR = radii; toR = Lib.get(shape); morphAnim.restart() }
    onTChanged: radii = Lib.lerp(fromR, toR, t)
    NumberAnimation { id: morphAnim; target: ms; property: "t"; from: 0; to: 1; duration: ms.duration
        easing.type: Easing.OutBack; easing.overshoot: 2.0 }

    function startSpin() { settle.stop(); spinA.from = ms.rotation; spinA.to = ms.rotation + 360; spinA.restart() }
    onSpinChanged: {
        if (spin) startSpin()
        else { spinA.stop(); ms.rotation = ms.rotation % 360; settle.restart() }
    }
    NumberAnimation { id: spinA; target: ms; property: "rotation"; duration: ms.spinPeriod; loops: Animation.Infinite }
    RotationAnimation { id: settle; target: ms; to: 0; direction: RotationAnimation.Shortest; duration: 450; easing.type: Easing.OutCubic }

    readonly property string d: {
        const r = radii, s = Math.min(width, height) / 2 * 0.98, cx = width / 2, cy = height / 2
        let p = ""
        for (let i = 0; i < Lib.N; i++) {
            const th = Lib.theta(i)
            p += (i ? "L" : "M") + (cx + r[i] * s * Math.cos(th)).toFixed(2) + " " + (cy + r[i] * s * Math.sin(th)).toFixed(2) + " "
        }
        return p + "Z"
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            fillColor: ms.color; strokeColor: "transparent"; strokeWidth: 0
            PathSvg { path: ms.d }
        }
    }
}
