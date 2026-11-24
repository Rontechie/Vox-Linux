import QtQuick
import QtQuick.Shapes
import qs.modules.nexus.compat
import qs.modules.nexus.services

Item {
    id: root

    property real implicitSize: 24
    property color color: Colours.palette.m3primary
    property bool animated: true
    property bool containsIcon: false
    property int morphAnimRotation: 60
    property real morphScale: 0.14

    implicitWidth: implicitSize
    implicitHeight: implicitSize

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: "transparent"
            strokeColor: root.color
            strokeWidth: Math.max(2, root.implicitSize / 8)
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root.width / 2 - Math.max(2, root.implicitSize / 8)
                radiusY: root.height / 2 - Math.max(2, root.implicitSize / 8)
                startAngle: 0
                sweepAngle: 270
            }
        }

        RotationAnimator on rotation {
            running: root.animated && root.visible
            from: 0
            to: 360
            duration: 900
            loops: Animation.Infinite
        }
    }
}
