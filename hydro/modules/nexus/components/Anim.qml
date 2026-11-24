import QtQuick
import qs.modules.nexus.compat

NumberAnimation {
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
        SlowSpatial,
        FastEffects,
        DefaultEffects,
        SlowEffects
    }

    property int type: Anim.DefaultSpatial

    duration: {
        if (type < Anim.StandardSmall || type > Anim.SlowEffects)
            return Tokens.anim.durations.normal;

        if (type === Anim.FastSpatial)
            return Tokens.anim.durations.expressiveFastSpatial;
        if (type === Anim.DefaultSpatial)
            return Tokens.anim.durations.expressiveDefaultSpatial;
        if (type === Anim.SlowSpatial)
            return Tokens.anim.durations.expressiveSlowSpatial;
        if (type === Anim.FastEffects)
            return Tokens.anim.durations.expressiveFastEffects;
        if (type === Anim.DefaultEffects)
            return Tokens.anim.durations.expressiveDefaultEffects;
        if (type === Anim.SlowEffects)
            return Tokens.anim.durations.expressiveSlowEffects;

        const types = ["small", "normal", "large", "extraLarge"];
        const idx = type % 4; // 0-7 are the 4 standard types
        return Tokens.anim.durations[types[idx]];
    }
    easing.type: Easing.BezierSpline
    easing.bezierCurve: {
        if (type === Anim.FastSpatial)
            return Tokens.curves.expressiveFastSpatial;
        if (type === Anim.DefaultSpatial)
            return Tokens.curves.expressiveDefaultSpatial;
        if (type === Anim.SlowSpatial)
            return Tokens.curves.expressiveSlowSpatial;
        if (type === Anim.FastEffects)
            return Tokens.curves.expressiveFastEffects;
        if (type === Anim.DefaultEffects)
            return Tokens.curves.expressiveDefaultEffects;
        if (type === Anim.SlowEffects)
            return Tokens.curves.expressiveSlowEffects;

        if (type >= Anim.EmphasizedSmall && type <= Anim.EmphasizedExtraLarge)
            return Tokens.curves.emphasized;
        return Tokens.curves.standard;
    }
}
