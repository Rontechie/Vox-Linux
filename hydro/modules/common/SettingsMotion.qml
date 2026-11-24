pragma Singleton
import Quickshell
import QtQuick
import qs.modules.common

Singleton {
    readonly property var spatial: Appearance.animationCurves.expressiveDefaultSpatial
    readonly property int spatialMs: Appearance.animationCurves.expressiveDefaultSpatialDuration
    readonly property var fastSpatial: Appearance.animationCurves.expressiveFastSpatial
    readonly property int fastSpatialMs: Appearance.animationCurves.expressiveFastSpatialDuration
    readonly property var effects: Appearance.animationCurves.expressiveEffects
    readonly property int effectsMs: Appearance.animationCurves.expressiveEffectsDuration
}
