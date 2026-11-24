import QtQuick
import qs.modules.nexus.compat

AnchorAnimation {
    enum Type {
        StandardSmall = 0,
        Standard,
        StandardLarge,
        StandardExtraLarge,
        EmphasizedSmall,
        Emphasized,
        EmphasizedLarge,
        EmphasizedExtraLarge,
        FastSpatial,
        DefaultSpatial,
        SlowSpatial
    }

    property int type: AnchorAnim.DefaultSpatial

    duration: {
        if (type < AnchorAnim.StandardSmall || type > AnchorAnim.SlowSpatial)
            return Tokens.anim.durations.expressiveDefaultSpatial;

        if (type == AnchorAnim.FastSpatial)
            return Tokens.anim.durations.expressiveFastSpatial;
        if (type == AnchorAnim.DefaultSpatial)
            return Tokens.anim.durations.expressiveDefaultSpatial;
        if (type == AnchorAnim.SlowSpatial)
            return Tokens.anim.durations.expressiveSlowSpatial;

        const types = ["small", "normal", "large", "extraLarge"];
        const idx = type % 4; // 0-7 are the 4 standard types
        return Tokens.anim.durations[types[idx]];
    }
    easing.type: Easing.BezierSpline
    easing.bezierCurve: {
        if (type == AnchorAnim.FastSpatial)
            return Tokens.curves.expressiveFastSpatial;
        if (type == AnchorAnim.DefaultSpatial)
            return Tokens.curves.expressiveDefaultSpatial;
        if (type == AnchorAnim.SlowSpatial)
            return Tokens.curves.expressiveSlowSpatial;

        if (type >= AnchorAnim.StandardSmall && type <= AnchorAnim.StandardExtraLarge)
            return Tokens.curves.standard;
        if (type >= AnchorAnim.EmphasizedSmall && type <= AnchorAnim.EmphasizedExtraLarge)
            return Tokens.curves.emphasized;

        return Tokens.curves.expressiveDefaultSpatial;
    }
}
