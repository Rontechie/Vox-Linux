import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services
import qs.modules.common.widgets
import qs.modules.common.widgets.settings
import qs.modules.settings.dms

GridPage {
    id: page
    readonly property var look: Config.options.appearance

    SettingsCard {
        id: paletteCard
        Layout.columnSpan: page.fullSpan
        title: Translation.tr("Palette style")
        iconName: "palette"
        readonly property var schemes: [
            { name: Translation.tr("Expressive"),  value: "scheme-expressive",  shape: MaterialShape.Shape.Sunny },
            { name: Translation.tr("Content"),     value: "scheme-content",     shape: MaterialShape.Shape.Clover4Leaf },
            { name: Translation.tr("Fidelity"),    value: "scheme-fidelity",    shape: MaterialShape.Shape.Gem },
            { name: Translation.tr("Fruit salad"), value: "scheme-fruit-salad", shape: MaterialShape.Shape.Flower },
            { name: Translation.tr("Monochrome"),  value: "scheme-monochrome",  shape: MaterialShape.Shape.Circle },
            { name: Translation.tr("Neutral"),     value: "scheme-neutral",     shape: MaterialShape.Shape.Pill },
            { name: Translation.tr("Rainbow"),     value: "scheme-rainbow",     shape: MaterialShape.Shape.Burst },
            { name: Translation.tr("Tonal spot"),  value: "scheme-tonal-spot",  shape: MaterialShape.Shape.Cookie6Sided }
        ]

        StyledText {
            Layout.fillWidth: true
            text: Translation.tr("How colors are derived from your wallpaper")
            font.pixelSize: SettingsTheme.fontSizeSmall
            color: SettingsTheme.surfaceVariantText
        }
        Flow {
            Layout.fillWidth: true
            spacing: 10
            Repeater {
                model: paletteCard.schemes
                delegate: ShapeChip {
                    required property var modelData
                    label: modelData.name
                    shape: modelData.shape
                    selected: Config.options.appearance.palette.type === modelData.value
                    onClicked: Config.options.appearance.palette.type = modelData.value
                }
            }
        }
    }

    SettingsCard {
        title: Translation.tr("Colors")
        iconName: "palette"

        SettingsDropdownRow {
            text: Translation.tr("Palette type")
            description: Translation.tr("How colors are derived from your wallpaper")
            options: ["Expressive", "Content", "Fidelity", "Fruit salad", "Monochrome", "Neutral", "Rainbow", "Tonal spot"]
            values: ["scheme-expressive", "scheme-content", "scheme-fidelity", "scheme-fruit-salad", "scheme-monochrome", "scheme-neutral", "scheme-rainbow", "scheme-tonal-spot"]
            currentValue: page.look.palette.type
            onValueChanged: v => Config.options.appearance.palette.type = v
        }
        SettingsDivider {}
        SettingsToggleRow {
            text: Translation.tr("Theme the shell and apps")
            checked: page.look.wallpaperTheming.enableAppsAndShell
            onToggled: c => Config.options.appearance.wallpaperTheming.enableAppsAndShell = c
        }
        SettingsToggleRow {
            text: Translation.tr("Theme Qt apps")
            checked: page.look.wallpaperTheming.enableQtApps
            onToggled: c => Config.options.appearance.wallpaperTheming.enableQtApps = c
        }
        SettingsToggleRow {
            text: Translation.tr("Theme the terminal")
            checked: page.look.wallpaperTheming.enableTerminal
            onToggled: c => Config.options.appearance.wallpaperTheming.enableTerminal = c
        }
    }

    SettingsCard {
        title: Translation.tr("Transparency")
        iconName: "blur_on"

        SettingsToggleRow {
            text: Translation.tr("Enable transparency")
            checked: page.look.transparency.enable
            onToggled: c => Config.options.appearance.transparency.enable = c
        }
        SettingsToggleRow {
            text: Translation.tr("Automatic")
            description: Translation.tr("Pick the amount from the wallpaper")
            checked: page.look.transparency.automatic
            onToggled: c => Config.options.appearance.transparency.automatic = c
        }
        SettingsSliderRow {
            text: Translation.tr("Background")
            from: 0
            to: 1
            stepSize: 0.01
            decimals: 2
            value: page.look.transparency.backgroundTransparency
            onSliderValueChanged: v => Config.options.appearance.transparency.backgroundTransparency = v
        }
        SettingsSliderRow {
            text: Translation.tr("Content")
            from: 0
            to: 1
            stepSize: 0.01
            decimals: 2
            value: page.look.transparency.contentTransparency
            onSliderValueChanged: v => Config.options.appearance.transparency.contentTransparency = v
        }
    }

    DmsTypography {
        Layout.columnSpan: page.fullSpan
    }
}
