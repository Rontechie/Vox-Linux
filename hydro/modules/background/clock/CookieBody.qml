import qs.modules.common
import qs.modules.common.widgets
import QtQuick

Item {
    id: root
    property int sides: 12
    property real bodySize: 100
    property color color: "white"
    property bool sine: false     // cookie.useSineCookie
    property bool spin: false     // cookie.constantlyRotate

    implicitWidth: bodySize
    implicitHeight: bodySize

    MaterialCookie {
        visible: !root.sine
        anchors.fill: parent
        implicitSize: root.bodySize
        sides: root.sides
        color: root.color
        RotationAnimator on rotation {
            from: 0; to: 360
            duration: 90000
            loops: Animation.Infinite
            running: root.spin && !root.sine
        }
    }
    SineCookie {
        visible: root.sine
        anchors.fill: parent
        implicitSize: Math.round(root.bodySize)
        sides: root.sides
        color: root.color
        constantlyRotate: root.spin
    }
}
