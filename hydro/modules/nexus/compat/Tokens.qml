pragma Singleton

import QtQuick
import Quickshell
import qs.modules.common as HC

Singleton {
    id: root

    property var screen: null
    readonly property real hydroRound: Math.max(0, HC.Config.options.appearance.roundness ?? 1)

    FontLoader {
        id: googleSansFlex
        source: Qt.resolvedUrl("../../../assets/google-sans-flex/GoogleSansFlex.ttf")
    }

    readonly property QtObject rounding: QtObject {
        readonly property int extraSmall: Math.round(4 * root.hydroRound)
        readonly property int small: Math.round(8 * root.hydroRound)
        readonly property int medium: Math.round(12 * root.hydroRound)
        readonly property int large: Math.round(16 * root.hydroRound)
        readonly property int largeIncreased: Math.round(20 * root.hydroRound)
        readonly property int extraLarge: Math.round(28 * root.hydroRound)
        readonly property int extraLargeIncreased: Math.round(32 * root.hydroRound)
        readonly property int extraExtraLarge: Math.round(48 * root.hydroRound)
        readonly property int full: 9999
        property real scale: 1
    }

    readonly property QtObject spacing: QtObject {
        readonly property int extraSmall: 4
        readonly property int small: 8
        readonly property int medium: 12
        readonly property int large: 16
        readonly property int largeIncreased: 20
        readonly property int extraLarge: 28
        readonly property int extraLargeIncreased: 32
        readonly property int extraExtraLarge: 48
    }

    readonly property QtObject padding: QtObject {
        readonly property int extraSmall: 4
        readonly property int small: 8
        readonly property int medium: 12
        readonly property int large: 16
        readonly property int largeIncreased: 20
        readonly property int extraLarge: 28
        readonly property int extraLargeIncreased: 32
        readonly property int extraExtraLarge: 48
    }

    readonly property QtObject anim: QtObject {
        readonly property QtObject durations: QtObject {
            property real scale: 1
            readonly property int small: 200
            readonly property int normal: 400
            readonly property int large: 600
            readonly property int extraLarge: 1000
            readonly property int expressiveFastSpatial: 350
            readonly property int expressiveDefaultSpatial: 500
            readonly property int expressiveSlowSpatial: 650
            readonly property int expressiveFastEffects: 150
            readonly property int expressiveDefaultEffects: 200
            readonly property int expressiveSlowEffects: 300
        }
    }

    readonly property QtObject curves: QtObject {
        readonly property var emphasized: [0.05, 0, 2.0 / 15.0, 0.06, 1.0 / 6.0, 0.4, 5.0 / 24.0, 0.82, 0.25, 1, 1, 1]
        readonly property var emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property var emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property var standard: [0.2, 0, 0, 1, 1, 1]
        readonly property var standardAccel: [0.3, 0, 1, 1, 1, 1]
        readonly property var standardDecel: [0, 0, 0, 1, 1, 1]
        readonly property var expressiveFastSpatial: [0.42, 1.67, 0.21, 0.9, 1, 1]
        readonly property var expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1, 1, 1]
        readonly property var expressiveSlowSpatial: [0.39, 1.29, 0.35, 0.98, 1, 1]
        readonly property var expressiveFastEffects: [0.31, 0.94, 0.34, 1, 1, 1]
        readonly property var expressiveDefaultEffects: [0.34, 0.8, 0.34, 1, 1, 1]
        readonly property var expressiveSlowEffects: [0.34, 0.88, 0.34, 1, 1, 1]
    }

    readonly property string sansFamily: "Google Sans Flex"
    readonly property string monoFamily: "CaskaydiaCove NF"
    readonly property string iconFamily: "Material Symbols Rounded"

    function makeFont(family, size, weight, vaxes) {
        const axes = Object.assign({ "opsz": size, "wght": weight }, vaxes || {});
        return Qt.font({
            "family": family,
            "pointSize": size,
            "weight": weight,
            "variableAxes": axes
        });
    }

    function builder(family, size, weight, vaxes) {
        return {
            "size": n => root.builder(family, n, weight, vaxes),
            "weight": w => root.builder(family, size, w, vaxes),
            "scale": k => root.builder(family, Math.round(size * k), weight, vaxes),
            "vaxes": v => root.builder(family, size, weight, Object.assign({}, vaxes, v || {})),
            "fill": v => root.builder(family, size, weight, Object.assign({}, vaxes, { "FILL": v })),
            "grade": v => root.builder(family, size, weight, Object.assign({}, vaxes, { "GRAD": v })),
            "build": () => root.makeFont(family, size, weight, vaxes)
        };
    }

    function fontStyle(family, large, medium, small, vaxes) {
        const sizes = { "large": large, "medium": medium, "small": small };
        const out = { "builders": ({}) };
        for (const k in sizes) {
            out[k] = root.makeFont(family, sizes[k][0], sizes[k][1], vaxes);
            out.builders[k] = root.builder(family, sizes[k][0], sizes[k][1], vaxes);
        }
        return out;
    }

    readonly property var font: {
        const rond = { "ROND": 25 };
        const icon = root.fontStyle(root.iconFamily, [24, Font.Normal], [24, Font.Normal], [24, Font.Normal], ({}));
        const iconSizes = { "small": 15, "medium": 18, "large": 24, "extraLarge": 36 };
        const iconStyle = { "builders": ({}) };
        for (const k in iconSizes) {
            iconStyle[k] = root.makeFont(root.iconFamily, iconSizes[k], Font.Normal, ({}));
            iconStyle.builders[k] = root.builder(root.iconFamily, iconSizes[k], Font.Normal, ({}));
        }
        iconStyle.size = n => root.builder(root.iconFamily, n, Font.Normal, ({}));
        return {
            "headline": root.fontStyle(root.sansFamily, [32, Font.Medium], [28, Font.Medium], [24, Font.Medium], rond),
            "title": root.fontStyle(root.sansFamily, [22, Font.Medium], [16, Font.Medium], [14, Font.Medium], rond),
            "body": root.fontStyle(root.sansFamily, [16, Font.Normal], [14, Font.Normal], [12, Font.Normal], rond),
            "label": root.fontStyle(root.sansFamily, [14, Font.Medium], [12, Font.Medium], [11, Font.Normal], rond),
            "mono": root.fontStyle(root.monoFamily, [16, Font.Normal], [14, Font.Normal], [12, Font.Normal], ({})),
            "icon": iconStyle
        };
    }

    readonly property QtObject sizes: QtObject {
        readonly property QtObject nexus: QtObject {
            readonly property real heightMult: 0.7
            readonly property real ratio: 16.0 / 9.0
            readonly property int minWidth: 800
            readonly property int minHeight: 500
            readonly property int maxNavWidth: 600
            readonly property int maxContentWidth: 800
            readonly property int popupWidth: 300
            readonly property int minPopupHeight: 200
            readonly property int maxPopupHeight: 800
            readonly property int networkShowEthDetailWidth: 620
            readonly property int networkShowVpnDetailWidth: 620
            readonly property int maxDialogWidth: 400
            readonly property int maxDialogHeight: 600
            readonly property int textFieldWidth: 250
            readonly property int smallTextFieldWidth: 100
        }
    }
}
