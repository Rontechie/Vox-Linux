import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services
import qs.modules.common.widgets
import qs.modules.common.widgets.settings
import qs.modules.settings.hydro

ContentPage {
    id: page
    readonly property var bar: Config.options.bar
    forceWidth: true
    baseWidth: Math.max(600, page.width - 48)

    GridLayout { // 1 column when narrow, 2 on a normal window, 3 on a wide one
        id: grid
        Layout.fillWidth: true
        columns: grid.width > 1700 ? 3 : (grid.width > 900 ? 2 : 1)
        columnSpacing: 20
        rowSpacing: 20

    SettingsCard {
        Layout.preferredWidth: 1
        Layout.alignment: Qt.AlignTop
        title: Translation.tr("Bar")
        iconName: "toast"

        SettingsToggleRow {
            text: Translation.tr("Bar at the bottom")
            description: Translation.tr("Off puts it at the top of the screen")
            checked: page.bar.bottom
            onToggled: c => Config.options.bar.bottom = c
        }
        SettingsDropdownRow {
            text: Translation.tr("Style")
            description: Translation.tr("How the bar sits against the screen edge")
            options: [Translation.tr("Hug"), Translation.tr("Float"), Translation.tr("Rectangle")]
            values: [0, 1, 2]
            currentValue: page.bar.cornerStyle
            onValueChanged: v => Config.options.bar.cornerStyle = v
        }
        SettingsDivider {}
        SettingsToggleRow {
            text: Translation.tr("Show background")
            checked: page.bar.showBackground
            onToggled: c => Config.options.bar.showBackground = c
        }
        SettingsToggleRow {
            text: Translation.tr("Auto-hide")
            checked: page.bar.autoHide.enable
            onToggled: c => Config.options.bar.autoHide.enable = c
        }
    }

    SettingsCard {
        Layout.preferredWidth: 1
        Layout.alignment: Qt.AlignTop
        id: shapeCard
        title: Translation.tr("Shape")
        iconName: "rounded_corner"
        readonly property var shp: page.bar.shape
        readonly property var roles: ["outline_variant", "outline", "primary", "secondary", "tertiary", "error", "on_surface", "surface_variant", "primary_container", "secondary_container", "surface_container_high"]

        SettingsSliderRow {
            text: Translation.tr("Corner radius")
            description: Translation.tr("Corner radius of the bar")
            from: 0
            to: 40
            stepSize: 1
            value: shapeCard.shp.cornerRadius
            onSliderValueChanged: v => {
                const s = Config.options.bar.shape;
                s.cornerRadius = Math.round(v);
                s.topLeft = -1; s.topRight = -1; s.bottomLeft = -1; s.bottomRight = -1; // all follow the main value
            }
        }
        SettingsToggleRow {
            text: Translation.tr("Concave edge corners")
            description: Translation.tr("Carve the bar's two inner corners when it touches the screen edge (Hug or Rectangle style)")
            checked: page.bar.shape.concaveEdgeCorners
            onToggled: c => Config.options.bar.shape.concaveEdgeCorners = c
        }
        SettingsDivider {}
        SettingsDropdownRow {
            text: Translation.tr("Border")
            description: Translation.tr("Color role for the bar outline")
            options: shapeCard.roles
            currentValue: page.bar.shape.borderColor
            onValueChanged: v => Config.options.bar.shape.borderColor = v
        }
        SettingsSliderRow {
            text: Translation.tr("Border width")
            description: Translation.tr("Inside outline width for the bar")
            from: 0
            to: 8
            stepSize: 0.5
            decimals: 1
            value: page.bar.shape.borderWidth
            onSliderValueChanged: v => Config.options.bar.shape.borderWidth = v
        }
    }

    SettingsCard {
        Layout.preferredWidth: 1
        Layout.alignment: Qt.AlignTop
        title: Translation.tr("Corner overrides")
        iconName: "crop_free"
        collapsible: true
        expanded: false

        SettingsSliderRow {
            text: Translation.tr("Top left")
            from: 0; to: 40; stepSize: 1
            value: page.bar.shape.topLeft >= 0 ? page.bar.shape.topLeft : page.bar.shape.cornerRadius
            onSliderValueChanged: v => Config.options.bar.shape.topLeft = Math.round(v)
        }
        SettingsSliderRow {
            text: Translation.tr("Top right")
            from: 0; to: 40; stepSize: 1
            value: page.bar.shape.topRight >= 0 ? page.bar.shape.topRight : page.bar.shape.cornerRadius
            onSliderValueChanged: v => Config.options.bar.shape.topRight = Math.round(v)
        }
        SettingsSliderRow {
            text: Translation.tr("Bottom left")
            from: 0; to: 40; stepSize: 1
            value: page.bar.shape.bottomLeft >= 0 ? page.bar.shape.bottomLeft : page.bar.shape.cornerRadius
            onSliderValueChanged: v => Config.options.bar.shape.bottomLeft = Math.round(v)
        }
        SettingsSliderRow {
            text: Translation.tr("Bottom right")
            from: 0; to: 40; stepSize: 1
            value: page.bar.shape.bottomRight >= 0 ? page.bar.shape.bottomRight : page.bar.shape.cornerRadius
            onSliderValueChanged: v => Config.options.bar.shape.bottomRight = Math.round(v)
        }
    }

    SettingsCard {
        Layout.preferredWidth: 1
        Layout.alignment: Qt.AlignTop
        title: Translation.tr("Size")
        iconName: "format_size"

        SettingsSliderRow {
            text: Translation.tr("Bar height")
            description: Translation.tr("Thickness of the bar in pixels")
            from: 32
            to: 56
            stepSize: 1
            value: page.bar.sizes.height
            onSliderValueChanged: v => Config.options.bar.sizes.height = Math.round(v)
        }
        SettingsSliderRow {
            text: Translation.tr("Widget size")
            description: Translation.tr("Scales icons, chips, the logo and the battery (capped to the bar height)")
            from: 0.7
            to: 1.3
            stepSize: 0.05
            decimals: 2
            value: page.bar.sizes.widgetScale
            onSliderValueChanged: v => Config.options.bar.sizes.widgetScale = v
        }
        SettingsSliderRow {
            text: Translation.tr("Font size")
            description: Translation.tr("Scales the text in the bar widgets")
            from: 0.7
            to: 1.5
            stepSize: 0.05
            decimals: 2
            value: page.bar.sizes.fontScale
            onSliderValueChanged: v => Config.options.bar.sizes.fontScale = v
        }
    }

    SettingsCard {
        Layout.preferredWidth: 1
        Layout.alignment: Qt.AlignTop
        title: Translation.tr("Capsules")
        iconName: "pill"

        SettingsToggleRow {
            text: Translation.tr("Widget capsules")
            description: Translation.tr("Wrap widgets in capsule backgrounds")
            checked: page.bar.capsules.enable
            onToggled: c => Config.options.bar.capsules.enable = c
        }
        SettingsSliderRow {
            text: Translation.tr("Capsule thickness")
            description: Translation.tr("Capsule size across the bar as a fraction of the bar thickness (1.0 fills the bar)")
            from: 0.5
            to: 1
            stepSize: 0.01
            decimals: 2
            value: page.bar.capsules.thickness
            onSliderValueChanged: v => Config.options.bar.capsules.thickness = v
        }
        SettingsSegmentedRow {
            text: Translation.tr("Capsule radius")
            description: Translation.tr("Auto makes full pills; Custom sets a fixed radius (0 = square corners)")
            options: [
                { displayName: Translation.tr("Auto"), value: true },
                { displayName: Translation.tr("Custom"), value: false }
            ]
            currentValue: page.bar.capsules.radiusAuto
            onSelected: v => Config.options.bar.capsules.radiusAuto = v
        }
        SettingsSliderRow {
            visible: !page.bar.capsules.radiusAuto
            text: Translation.tr("Custom radius")
            from: 0
            to: 20
            stepSize: 1
            value: page.bar.capsules.radius
            onSliderValueChanged: v => Config.options.bar.capsules.radius = Math.round(v)
        }
    }

    SettingsCard {
        Layout.preferredWidth: 1
        Layout.alignment: Qt.AlignTop
        Layout.columnSpan: grid.columns
        title: Translation.tr("Widget List")
        iconName: "view_week"

        Loader {
            id: lanesLoader
            Layout.fillWidth: true
            source: "WidgetLanes.qml"
            onStatusChanged: if (status === Loader.Error) console.warn("[hydro] WidgetLanes.qml failed to load, using the simple widget editor")
        }

        ColumnLayout {
            visible: lanesLoader.status === Loader.Error
            Layout.fillWidth: true
            spacing: 12

            StyledText {
                Layout.fillWidth: true
                Layout.leftMargin: SettingsTheme.spacingM
                wrapMode: Text.WordWrap
                text: Translation.tr("The lane editor failed to load, so this is the simple editor. Check the log: qs -c hydro log | grep -i error")
                font.pixelSize: SettingsTheme.fontSizeSmall
                color: SettingsTheme.surfaceVariantText
            }
            LayoutEditor {
                title: Translation.tr("Start")
                current: page.bar.hydroLayout.left
                onEdited: l => Config.options.bar.hydroLayout.left = l
            }
            LayoutEditor {
                title: Translation.tr("Center")
                current: page.bar.hydroLayout.center
                onEdited: l => Config.options.bar.hydroLayout.center = l
            }
            LayoutEditor {
                title: Translation.tr("End")
                current: page.bar.hydroLayout.right
                onEdited: l => Config.options.bar.hydroLayout.right = l
            }
        }
    }

    SettingsCard {
        Layout.preferredWidth: 1
        Layout.alignment: Qt.AlignTop
        title: Translation.tr("Workspaces")
        iconName: "workspaces"

        SettingsSegmentedRow {
            text: Translation.tr("Theme")
            options: [
                { displayName: Translation.tr("Pills"), value: "pills" },
                { displayName: Translation.tr("Numbers"), value: "numbers" },
                { displayName: Translation.tr("Dots"), value: "dots" },
                { displayName: "Pac-Man", value: "pacman" }
            ]
            currentValue: page.bar.workspaces.theme
            onSelected: v => Config.options.bar.workspaces.theme = v
        }
        SettingsToggleRow {
            visible: page.bar.workspaces.theme === "pacman"
            text: Translation.tr("Numbers as pellets")
            checked: page.bar.workspaces.pacmanNumbers
            onToggled: c => Config.options.bar.workspaces.pacmanNumbers = c
        }
        SettingsSliderRow {
            text: Translation.tr("Workspaces shown")
            from: 1
            to: 10
            stepSize: 1
            value: page.bar.workspaces.shown
            onSliderValueChanged: v => Config.options.bar.workspaces.shown = Math.round(v)
        }
        SettingsToggleRow {
            text: Translation.tr("Show app icons")
            checked: page.bar.workspaces.showAppIcons
            onToggled: c => Config.options.bar.workspaces.showAppIcons = c
        }
        SettingsToggleRow {
            text: Translation.tr("Monochrome icons")
            checked: page.bar.workspaces.monochromeIcons
            onToggled: c => Config.options.bar.workspaces.monochromeIcons = c
        }
        SettingsToggleRow {
            text: Translation.tr("Always show numbers")
            checked: page.bar.workspaces.alwaysShowNumbers
            onToggled: c => Config.options.bar.workspaces.alwaysShowNumbers = c
        }
    }

    SettingsCard {
        Layout.preferredWidth: 1
        Layout.alignment: Qt.AlignTop
        title: Translation.tr("Indicators")
        iconName: "monitoring"

        SettingsToggleRow {
            text: Translation.tr("Unread notification count")
            checked: page.bar.indicators.notifications.showUnreadCount
            onToggled: c => Config.options.bar.indicators.notifications.showUnreadCount = c
        }
        SettingsToggleRow {
            text: Translation.tr("Always show CPU")
            checked: page.bar.resources.alwaysShowCpu
            onToggled: c => Config.options.bar.resources.alwaysShowCpu = c
        }
        SettingsToggleRow {
            text: Translation.tr("Always show swap")
            checked: page.bar.resources.alwaysShowSwap
            onToggled: c => Config.options.bar.resources.alwaysShowSwap = c
        }
    }

    SettingsCard {
        Layout.preferredWidth: 1
        Layout.alignment: Qt.AlignTop
        title: Translation.tr("Utility buttons")
        iconName: "apps"
        collapsible: true
        expanded: false

        SettingsToggleRow {
            text: Translation.tr("Screen snip")
            checked: page.bar.utilButtons.showScreenSnip
            onToggled: c => Config.options.bar.utilButtons.showScreenSnip = c
        }
        SettingsToggleRow {
            text: Translation.tr("Color picker")
            checked: page.bar.utilButtons.showColorPicker
            onToggled: c => Config.options.bar.utilButtons.showColorPicker = c
        }
        SettingsToggleRow {
            text: Translation.tr("Mic toggle")
            checked: page.bar.utilButtons.showMicToggle
            onToggled: c => Config.options.bar.utilButtons.showMicToggle = c
        }
        SettingsToggleRow {
            text: Translation.tr("Keyboard toggle")
            checked: page.bar.utilButtons.showKeyboardToggle
            onToggled: c => Config.options.bar.utilButtons.showKeyboardToggle = c
        }
        SettingsToggleRow {
            text: Translation.tr("Dark mode toggle")
            checked: page.bar.utilButtons.showDarkModeToggle
            onToggled: c => Config.options.bar.utilButtons.showDarkModeToggle = c
        }
        SettingsToggleRow {
            text: Translation.tr("Screen record")
            checked: page.bar.utilButtons.showScreenRecord
            onToggled: c => Config.options.bar.utilButtons.showScreenRecord = c
        }
    }
    }
}
