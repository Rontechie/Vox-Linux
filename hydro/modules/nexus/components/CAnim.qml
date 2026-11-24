import QtQuick
import qs.modules.nexus.compat

ColorAnimation {
    duration: Tokens.anim.durations.expressiveSlowEffects
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Tokens.curves.expressiveSlowEffects
}
