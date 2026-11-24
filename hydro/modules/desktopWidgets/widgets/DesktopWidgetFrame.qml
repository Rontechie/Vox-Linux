import QtQuick
import qs.modules.desktopWidgets.ui

Item {
    id: dwf
    property bool dwOn: false
    property bool dragging: false
    property bool resizable: false
    visible: dwOn || opacity > 0.01
    opacity: dwOn ? 1 : 0
    scale: dwOn ? 1 : 0.9
    Behavior on opacity { M3NumberAnim { duration: HwState.profileMorphing ? 520 : 300 } }
    Behavior on scale   { NumberAnimation { duration: HwState.profileMorphing ? 620 : 340; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
    Behavior on x { enabled: !dwf.dragging && !(dwf.resizable && HwLayer.resizingEdge); NumberAnimation { duration: HwState.profileMorphing ? 700 : 220; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
    Behavior on y { enabled: !dwf.dragging && !(dwf.resizable && HwLayer.resizingEdge); NumberAnimation { duration: HwState.profileMorphing ? 700 : 220; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
    Behavior on width  { enabled: HwState.profileMorphing; M3SpringAnim { token: "spatialSlow" } }
    Behavior on height { enabled: HwState.profileMorphing; M3SpringAnim { token: "spatialSlow" } }
    transform: [
        Scale {
            origin.x: 0; origin.y: 0
            xScale: HwLayer.animScale
            yScale: HwLayer.animScale
        },
        Translate {
            x: (HwLayer.widgetBoxX + dwf.x * HwLayer.animScale - dwf.x)
            y: (HwLayer.widgetBoxY + dwf.y * HwLayer.animScale - dwf.y)
        }
    ]
}
