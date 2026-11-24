pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.modules.common as HC
import qs.modules.desktopWidgets.ui
import qs.modules.nexus.compat
import qs.modules.nexus.components
import qs.modules.nexus.components.controls
import qs.modules.nexus.services
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Desktop widgets")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Layout")
        }

        RowGroup {
            ToggleRow {
                text: Tr.tr("Edit mode")
                subtext: Tr.tr("Drag widgets on the desktop, they snap to a grid")
                checked: HwConfig.editMode
                onToggled: {
                    HwConfig.editMode = checked;
                    checked = Qt.binding(() => HwConfig.editMode);
                }
            }
            CfgSlider {
                obj: HwConfig.general
                key: "fontScale"
                label: Tr.tr("Text size")
                from: 0.8
                to: 1.4
                stepSize: 0.05
                decimals: 2
                unit: "x"
            }
            CfgToggle {
                obj: HwConfig.general
                key: "snapToGrid"
                text: Tr.tr("Snap to grid")
                subtext: Tr.tr("Dragging and the X / Y sliders snap to the grid")
            }
            CfgSlider {
                obj: HwConfig.general
                key: "gridSize"
                label: Tr.tr("Grid size")
                from: 5
                to: 100
                stepSize: 5
                unit: "px"
            }
            CfgSlider {
                obj: HwConfig.general
                key: "edgeMargin"
                label: Tr.tr("Screen edge margin")
                subtext: Tr.tr("Used by the position presets")
                from: 0
                to: 300
                stepSize: 10
                unit: "px"
            }
        }

        SectionHeader {
            text: Tr.tr("Media position")
        }

        RowGroup {
            CfgSelect {
                obj: HwConfig.media
                key: "anchor"
                label: Tr.tr("Position")
                options: [
                    { text: Tr.tr("Custom (use X / Y)"), value: "custom" },
                    { text: Tr.tr("Top left"), value: "top-left" },
                    { text: Tr.tr("Top"), value: "top" },
                    { text: Tr.tr("Top right"), value: "top-right" },
                    { text: Tr.tr("Left"), value: "left" },
                    { text: Tr.tr("Center"), value: "center" },
                    { text: Tr.tr("Right"), value: "right" },
                    { text: Tr.tr("Bottom left"), value: "bottom-left" },
                    { text: Tr.tr("Bottom"), value: "bottom" },
                    { text: Tr.tr("Bottom right"), value: "bottom-right" }
                ]
            }
            CfgSlider {
                obj: HwConfig.media
                key: "x"
                label: Tr.tr("X (custom)")
                from: 0
                to: 4000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
            CfgSlider {
                obj: HwConfig.media
                key: "y"
                label: Tr.tr("Y (custom)")
                from: 0
                to: 3000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
        }

        SectionHeader {
            text: Tr.tr("Lyrics position")
        }

        RowGroup {
            CfgSelect {
                obj: HwConfig.lyrics
                key: "anchor"
                label: Tr.tr("Position")
                options: [
                    { text: Tr.tr("Custom (use X / Y)"), value: "custom" },
                    { text: Tr.tr("Top left"), value: "top-left" },
                    { text: Tr.tr("Top"), value: "top" },
                    { text: Tr.tr("Top right"), value: "top-right" },
                    { text: Tr.tr("Left"), value: "left" },
                    { text: Tr.tr("Center"), value: "center" },
                    { text: Tr.tr("Right"), value: "right" },
                    { text: Tr.tr("Bottom left"), value: "bottom-left" },
                    { text: Tr.tr("Bottom"), value: "bottom" },
                    { text: Tr.tr("Bottom right"), value: "bottom-right" }
                ]
            }
            CfgSlider {
                obj: HwConfig.lyrics
                key: "x"
                label: Tr.tr("X (custom)")
                from: 0
                to: 4000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
            CfgSlider {
                obj: HwConfig.lyrics
                key: "y"
                label: Tr.tr("Y (custom)")
                from: 0
                to: 3000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
        }

        SectionHeader {
            text: Tr.tr("Weather position")
        }

        RowGroup {
            CfgSelect {
                obj: HwConfig.weather
                key: "anchor"
                label: Tr.tr("Position")
                options: [
                    { text: Tr.tr("Custom (use X / Y)"), value: "custom" },
                    { text: Tr.tr("Top left"), value: "top-left" },
                    { text: Tr.tr("Top"), value: "top" },
                    { text: Tr.tr("Top right"), value: "top-right" },
                    { text: Tr.tr("Left"), value: "left" },
                    { text: Tr.tr("Center"), value: "center" },
                    { text: Tr.tr("Right"), value: "right" },
                    { text: Tr.tr("Bottom left"), value: "bottom-left" },
                    { text: Tr.tr("Bottom"), value: "bottom" },
                    { text: Tr.tr("Bottom right"), value: "bottom-right" }
                ]
            }
            CfgSlider {
                obj: HwConfig.weather
                key: "x"
                label: Tr.tr("X (custom)")
                from: 0
                to: 4000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
            CfgSlider {
                obj: HwConfig.weather
                key: "y"
                label: Tr.tr("Y (custom)")
                from: 0
                to: 3000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
        }

        SectionHeader {
            text: Tr.tr("System position")
        }

        RowGroup {
            CfgSelect {
                obj: HwConfig.system
                key: "anchor"
                label: Tr.tr("Position")
                options: [
                    { text: Tr.tr("Custom (use X / Y)"), value: "custom" },
                    { text: Tr.tr("Top left"), value: "top-left" },
                    { text: Tr.tr("Top"), value: "top" },
                    { text: Tr.tr("Top right"), value: "top-right" },
                    { text: Tr.tr("Left"), value: "left" },
                    { text: Tr.tr("Center"), value: "center" },
                    { text: Tr.tr("Right"), value: "right" },
                    { text: Tr.tr("Bottom left"), value: "bottom-left" },
                    { text: Tr.tr("Bottom"), value: "bottom" },
                    { text: Tr.tr("Bottom right"), value: "bottom-right" }
                ]
            }
            CfgSlider {
                obj: HwConfig.system
                key: "x"
                label: Tr.tr("X (custom)")
                from: 0
                to: 4000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
            CfgSlider {
                obj: HwConfig.system
                key: "y"
                label: Tr.tr("Y (custom)")
                from: 0
                to: 3000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
        }

        SectionHeader {
            text: Tr.tr("Gauge position")
        }

        RowGroup {
            CfgSelect {
                obj: HwConfig.gauge
                key: "anchor"
                label: Tr.tr("Position")
                options: [
                    { text: Tr.tr("Custom (use X / Y)"), value: "custom" },
                    { text: Tr.tr("Top left"), value: "top-left" },
                    { text: Tr.tr("Top"), value: "top" },
                    { text: Tr.tr("Top right"), value: "top-right" },
                    { text: Tr.tr("Left"), value: "left" },
                    { text: Tr.tr("Center"), value: "center" },
                    { text: Tr.tr("Right"), value: "right" },
                    { text: Tr.tr("Bottom left"), value: "bottom-left" },
                    { text: Tr.tr("Bottom"), value: "bottom" },
                    { text: Tr.tr("Bottom right"), value: "bottom-right" }
                ]
            }
            CfgSlider {
                obj: HwConfig.gauge
                key: "x"
                label: Tr.tr("X (custom)")
                from: 0
                to: 4000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
            CfgSlider {
                obj: HwConfig.gauge
                key: "y"
                label: Tr.tr("Y (custom)")
                from: 0
                to: 3000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
        }

        SectionHeader {
            text: Tr.tr("Stopwatch position")
        }

        RowGroup {
            CfgSelect {
                obj: HwConfig.stopwatch
                key: "anchor"
                label: Tr.tr("Position")
                options: [
                    { text: Tr.tr("Custom (use X / Y)"), value: "custom" },
                    { text: Tr.tr("Top left"), value: "top-left" },
                    { text: Tr.tr("Top"), value: "top" },
                    { text: Tr.tr("Top right"), value: "top-right" },
                    { text: Tr.tr("Left"), value: "left" },
                    { text: Tr.tr("Center"), value: "center" },
                    { text: Tr.tr("Right"), value: "right" },
                    { text: Tr.tr("Bottom left"), value: "bottom-left" },
                    { text: Tr.tr("Bottom"), value: "bottom" },
                    { text: Tr.tr("Bottom right"), value: "bottom-right" }
                ]
            }
            CfgSlider {
                obj: HwConfig.stopwatch
                key: "x"
                label: Tr.tr("X (custom)")
                from: 0
                to: 4000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
            CfgSlider {
                obj: HwConfig.stopwatch
                key: "y"
                label: Tr.tr("Y (custom)")
                from: 0
                to: 3000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
        }

        SectionHeader {
            text: Tr.tr("Player with lyrics")
        }

        RowGroup {
            CfgToggle {
                obj: HwConfig.player
                key: "enable"
                text: Tr.tr("Player with lyrics")
                subtext: Tr.tr("Now playing on top, synced lyrics below")
            }
            CfgToggle {
                obj: HwConfig.player
                key: "showLyrics"
                text: Tr.tr("Show lyrics")
            }
            CfgSelect {
                obj: HwConfig.player
                key: "theme"
                label: Tr.tr("Lyric look")
                options: [
                    { text: Tr.tr("Theme colours"), value: "default" },
                    { text: Tr.tr("Cinematic"), value: "cinematic" },
                    { text: Tr.tr("Neon"), value: "neon" },
                    { text: Tr.tr("Editorial"), value: "editorial" },
                    { text: Tr.tr("Nocturne"), value: "nocturne" },
                    { text: Tr.tr("Neon script"), value: "neonScript" },
                    { text: Tr.tr("Edit"), value: "kinetic" },
                    { text: Tr.tr("Motion"), value: "motion" }
                ]
            }
            CfgSelect {
                obj: HwConfig.player
                key: "align"
                label: Tr.tr("Alignment")
                options: [
                    { text: Tr.tr("Left"), value: "left" },
                    { text: Tr.tr("Center"), value: "center" },
                    { text: Tr.tr("Right"), value: "right" }
                ]
            }
            CfgSelect {
                obj: HwConfig.player
                key: "artShape"
                label: Tr.tr("Cover shape")
                options: [
                    { text: Tr.tr("Rounded square"), value: "Square" },
                    { text: Tr.tr("Cookie"), value: "Cookie9Sided" },
                    { text: Tr.tr("Circle"), value: "Circle" },
                    { text: Tr.tr("Soft burst"), value: "SoftBurst" },
                    { text: Tr.tr("Flower"), value: "Flower" },
                    { text: Tr.tr("Clover"), value: "Clover4Leaf" },
                    { text: Tr.tr("Heart"), value: "Heart" }
                ]
            }
            CfgSlider {
                obj: HwConfig.player
                key: "scale"
                label: Tr.tr("Size")
                from: 0.6
                to: 1.8
                stepSize: 0.05
                decimals: 2
                unit: "x"
            }
            CfgSelect {
                obj: HwConfig.player
                key: "anchor"
                label: Tr.tr("Position")
                options: [
                    { text: Tr.tr("Custom (use X / Y)"), value: "custom" },
                    { text: Tr.tr("Top left"), value: "top-left" },
                    { text: Tr.tr("Top"), value: "top" },
                    { text: Tr.tr("Top right"), value: "top-right" },
                    { text: Tr.tr("Left"), value: "left" },
                    { text: Tr.tr("Center"), value: "center" },
                    { text: Tr.tr("Right"), value: "right" },
                    { text: Tr.tr("Bottom left"), value: "bottom-left" },
                    { text: Tr.tr("Bottom"), value: "bottom" },
                    { text: Tr.tr("Bottom right"), value: "bottom-right" }
                ]
            }
            CfgSlider {
                obj: HwConfig.player
                key: "x"
                label: Tr.tr("X (custom)")
                from: 0
                to: 4000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
            CfgSlider {
                obj: HwConfig.player
                key: "y"
                label: Tr.tr("Y (custom)")
                from: 0
                to: 3000
                stepSize: HwConfig.general.snapToGrid ? HwConfig.general.gridSize : 10
                unit: "px"
            }
        }

        SectionHeader {
            text: Tr.tr("Media")
        }

        RowGroup {
            CfgToggle {
                obj: HwConfig.media
                key: "enable"
                text: Tr.tr("Now playing")
            }
            CfgSelect {
                obj: HwConfig.media
                key: "artStyle"
                label: Tr.tr("Album art")
                options: [
                    { text: Tr.tr("Shape"), value: "shape" },
                    { text: Tr.tr("Gear with progress ring"), value: "gear" }
                ]
            }
            CfgSelect {
                obj: HwConfig.media
                key: "shape"
                label: Tr.tr("Art shape")
                options: [
                    { text: Tr.tr("Cookie"), value: "Cookie9Sided" },
                    { text: Tr.tr("Circle"), value: "Circle" },
                    { text: Tr.tr("Soft burst"), value: "SoftBurst" },
                    { text: Tr.tr("Flower"), value: "Flower" },
                    { text: Tr.tr("Clover"), value: "Clover4Leaf" },
                    { text: Tr.tr("Pentagon"), value: "Pentagon" },
                    { text: Tr.tr("Heart"), value: "Heart" }
                ]
            }
            CfgToggle {
                obj: HwConfig.media
                key: "showLyric"
                text: Tr.tr("Show current lyric")
            }
            CfgSlider {
                obj: HwConfig.media
                key: "scale"
                label: Tr.tr("Size")
                from: 0.6
                to: 1.8
                stepSize: 0.05
                decimals: 2
                unit: "x"
            }
        }

        RowGroup {
            Layout.topMargin: Tokens.spacing.large

            CfgToggle {
                obj: HwConfig.lyrics
                key: "enable"
                text: Tr.tr("Lyrics")
                subtext: Tr.tr("Synced lyrics, tap a line to seek")
            }
            CfgSelect {
                obj: HwConfig.lyrics
                key: "theme"
                label: Tr.tr("Lyric theme")
                subtext: Tr.tr("Reel plays lyrics like a lyric video")
                options: [
                    { text: Tr.tr("Classic (simple)"), value: "classic" },
                    { text: Tr.tr("Reel (lyric video)"), value: "reel" },
                    { text: Tr.tr("Theme colours"), value: "default" },
                    { text: Tr.tr("Cinematic"), value: "cinematic" },
                    { text: Tr.tr("Neon"), value: "neon" },
                    { text: Tr.tr("Editorial"), value: "editorial" },
                    { text: Tr.tr("Nocturne"), value: "nocturne" },
                    { text: Tr.tr("Neon script"), value: "neonScript" },
                    { text: Tr.tr("Edit"), value: "kinetic" },
                    { text: Tr.tr("Motion"), value: "motion" }
                ]
            }
            CfgSelect {
                obj: HC.Config.options.media
                key: "reelCamera"
                label: Tr.tr("Reel camera")
                subtext: Tr.tr("How much the camera pushes and punches")
                options: [
                    { text: Tr.tr("Off"), value: "off" },
                    { text: Tr.tr("Subtle"), value: "subtle" },
                    { text: Tr.tr("Normal"), value: "normal" },
                    { text: Tr.tr("Strong"), value: "strong" }
                ]
            }
            CfgSelect {
                obj: HC.Config.options.media
                key: "reelBeats"
                label: Tr.tr("Reel beat reaction")
                subtext: Tr.tr("Needs cava installed")
                options: [
                    { text: Tr.tr("Off"), value: "off" },
                    { text: Tr.tr("Light"), value: "light" },
                    { text: Tr.tr("Strong"), value: "strong" }
                ]
            }
            CfgSelect {
                obj: HC.Config.options.media
                key: "reelTransitions"
                label: Tr.tr("Reel transitions")
                options: [
                    { text: Tr.tr("Each look's own"), value: "look" },
                    { text: Tr.tr("Mixed every line"), value: "mixed" }
                ]
            }
            CfgSelect {
                obj: HwConfig.lyrics
                key: "align"
                label: Tr.tr("Alignment")
                options: [
                    { text: Tr.tr("Left"), value: "left" },
                    { text: Tr.tr("Center"), value: "center" },
                    { text: Tr.tr("Right"), value: "right" }
                ]
            }
            CfgSlider {
                obj: HwConfig.lyrics
                key: "scale"
                label: Tr.tr("Size")
                from: 0.6
                to: 1.8
                stepSize: 0.05
                decimals: 2
                unit: "x"
            }
        }

        SectionHeader {
            text: Tr.tr("Weather")
        }

        RowGroup {
            CfgToggle {
                obj: HwConfig.weather
                key: "enable"
                text: Tr.tr("Weather")
                subtext: Tr.tr("Uses the city and units from Language & region")
            }
            CfgToggle {
                obj: HwConfig.weather
                key: "shapedCards"
                text: Tr.tr("Shaped forecast cards")
            }
            CfgToggle {
                obj: HwConfig.weather
                key: "waveEffect"
                text: Tr.tr("Animated waves")
            }
            CfgSlider {
                obj: HwConfig.weather
                key: "scale"
                label: Tr.tr("Size")
                from: 0.6
                to: 1.8
                stepSize: 0.05
                decimals: 2
                unit: "x"
            }
        }

        SectionHeader {
            text: Tr.tr("System")
        }

        RowGroup {
            CfgToggle {
                obj: HwConfig.system
                key: "enable"
                text: Tr.tr("CPU, memory and swap")
            }
            CfgSlider {
                obj: HwConfig.system
                key: "scale"
                label: Tr.tr("Size")
                from: 0.6
                to: 1.8
                stepSize: 0.05
                decimals: 2
                unit: "x"
            }
        }

        RowGroup {
            Layout.topMargin: Tokens.spacing.large

            CfgToggle {
                obj: HwConfig.gauge
                key: "enable"
                text: Tr.tr("Liquid gauge")
            }
            CfgSelect {
                obj: HwConfig.gauge
                key: "metric"
                label: Tr.tr("Shows")
                options: [
                    { text: Tr.tr("Memory"), value: "ram" },
                    { text: Tr.tr("CPU"), value: "cpu" }
                ]
            }
            CfgSelect {
                obj: HwConfig.gauge
                key: "shape"
                label: Tr.tr("Shape")
                options: [
                    { text: Tr.tr("Squircle"), value: "squircle" },
                    { text: Tr.tr("Arch"), value: "arch" },
                    { text: Tr.tr("Pill"), value: "pill" },
                    { text: Tr.tr("Fan"), value: "fan" }
                ]
            }
            CfgToggle {
                obj: HwConfig.gauge
                key: "waveEffect"
                text: Tr.tr("Animated waves")
            }
            CfgSlider {
                obj: HwConfig.gauge
                key: "scale"
                label: Tr.tr("Size")
                from: 0.6
                to: 1.8
                stepSize: 0.05
                decimals: 2
                unit: "x"
            }
        }

        SectionHeader {
            text: Tr.tr("Tools")
        }

        RowGroup {
            CfgToggle {
                obj: HwConfig.stopwatch
                key: "enable"
                text: Tr.tr("Stopwatch")
            }
            CfgSlider {
                obj: HwConfig.stopwatch
                key: "scale"
                label: Tr.tr("Size")
                from: 0.6
                to: 1.8
                stepSize: 0.05
                decimals: 2
                unit: "x"
            }
        }

        SectionHeader {
            text: Tr.tr("Audio visualiser")
        }

        RowGroup {
            CfgToggle {
                obj: HwConfig.cava
                key: "enable"
                text: Tr.tr("Cava visualiser")
                subtext: HwCava.failed ? Tr.tr("cava did not start, is it installed?") : Tr.tr("Needs the cava package")
            }
            CfgSelect {
                obj: HwConfig.cava
                key: "style"
                label: Tr.tr("Style")
                options: [
                    { text: Tr.tr("Bars"), value: "bars" },
                    { text: Tr.tr("Wave"), value: "wave" }
                ]
            }
            CfgSelect {
                obj: HwConfig.cava
                key: "edge"
                label: Tr.tr("Screen edge")
                options: [
                    { text: Tr.tr("Bottom"), value: "bottom" },
                    { text: Tr.tr("Top"), value: "top" },
                    { text: Tr.tr("Left"), value: "left" },
                    { text: Tr.tr("Right"), value: "right" }
                ]
            }
            CfgSlider {
                obj: HwConfig.cava
                key: "height"
                label: Tr.tr("Height")
                from: 60
                to: 400
                stepSize: 10
                decimals: 0
                unit: "px"
            }
            CfgStepper {
                obj: HwConfig.cava
                key: "resolution"
                label: Tr.tr("Bars")
                from: 16
                to: 128
                stepSize: 8
            }
        }

        Item { Layout.preferredHeight: Tokens.padding.extraLarge }
    }
}
