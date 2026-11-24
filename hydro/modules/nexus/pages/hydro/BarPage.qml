pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.modules.common as HC
import qs.modules.nexus.compat
import qs.modules.nexus.components
import qs.modules.nexus.components.controls
import qs.modules.nexus.services
import qs.modules.nexus.common

PageBase {
    id: root

    readonly property var bar: HC.Config.options.bar

    title: Tr.tr("Bar")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Position & style")
        }

        RowGroup {
            CfgToggle {
                obj: root.bar
                key: "bottom"
                text: Tr.tr("Bar at the bottom")
            }
            CfgSelect {
                obj: root.bar
                key: "cornerStyle"
                label: Tr.tr("Style")
                subtext: Tr.tr("How the bar sits on the screen edge")
                options: [
                    {
                        text: Tr.tr("Hug"),
                        value: 0
                    },
                    {
                        text: Tr.tr("Float"),
                        value: 1
                    },
                    {
                        text: Tr.tr("Rectangle"),
                        value: 2
                    }
                ]
            }
            CfgToggle {
                obj: root.bar
                key: "showBackground"
                text: Tr.tr("Show background")
            }
            CfgToggle {
                obj: root.bar.autoHide
                key: "enable"
                text: Tr.tr("Auto-hide")
                subtext: Tr.tr("Hide the bar until you move the pointer to the screen edge")
            }
        }

        SectionHeader {
            text: Tr.tr("Margins")
        }

        RowGroup {
            CfgSlider {
                obj: root.bar.margins
                key: "ends"
                label: Tr.tr("Ends margin")
                subtext: Tr.tr("Shortens the bar from both ends; 0 for a full-width bar")
                from: 0
                to: 400
                stepSize: 1
                unit: " px"
            }
            CfgSlider {
                obj: root.bar.margins
                key: "edge"
                label: Tr.tr("Edge margin")
                subtext: Tr.tr("Gap between the bar and the screen edge; 0 sits flush")
                from: 0
                to: 40
                stepSize: 1
                unit: " px"
            }
            CfgSlider {
                obj: root.bar.margins
                key: "opposite"
                label: Tr.tr("Opposite edge margin")
                subtext: Tr.tr("Extra reserved space on the inward side of the bar")
                from: 0
                to: 40
                stepSize: 1
                unit: " px"
            }
        }

        SectionHeader {
            text: Tr.tr("Size")
        }

        RowGroup {
            CfgSlider {
                obj: root.bar.sizes
                key: "height"
                label: Tr.tr("Bar height")
                from: 32
                to: 56
                stepSize: 1
                unit: " px"
            }
            CfgSlider {
                obj: root.bar.sizes
                key: "widgetScale"
                label: Tr.tr("Widget size")
                from: 0.7
                to: 1.3
                stepSize: 0.05
                decimals: 2
                unit: "x"
            }
            CfgSlider {
                obj: root.bar.sizes
                key: "fontScale"
                label: Tr.tr("Font size")
                from: 0.7
                to: 1.5
                stepSize: 0.05
                decimals: 2
                unit: "x"
            }
        }

        SectionHeader {
            text: Tr.tr("Shape")
        }

        RowGroup {
            CfgSlider {
                obj: root.bar.shape
                key: "cornerRadius"
                label: Tr.tr("Corner radius")
                from: 0
                to: 40
                stepSize: 1
                unit: " px"
            }
            CfgToggle {
                obj: root.bar.shape
                key: "concaveEdgeCorners"
                text: Tr.tr("Concave edge corners")
            }
            CfgSelect {
                obj: root.bar.shape
                key: "borderColor"
                label: Tr.tr("Border colour")
                subtext: Tr.tr("Colour role for the bar outline")
                options: ["outline_variant", "outline", "primary", "secondary", "tertiary", "error", "on_surface", "surface_variant", "primary_container", "secondary_container", "surface_container_high"].map(r => ({
                            text: r.replace(/_/g, " "),
                            value: r
                        }))
            }
            CfgSlider {
                obj: root.bar.shape
                key: "borderWidth"
                label: Tr.tr("Border width")
                from: 0
                to: 8
                stepSize: 0.5
                decimals: 1
                unit: " px"
            }
        }

        SectionHeader {
            text: Tr.tr("Islands")
        }

        RowGroup {
            CfgToggle {
                obj: root.bar.islands
                key: "enable"
                text: Tr.tr("Modular islands")
                subtext: Tr.tr("Every widget floats on its own plate and the bar background disappears")
            }
            CfgSlider {
                obj: root.bar.islands
                key: "thickness"
                label: Tr.tr("Island thickness")
                from: 0.5
                to: 1
                stepSize: 0.01
                decimals: 2
            }
            CfgSlider {
                obj: root.bar.islands
                key: "padding"
                label: Tr.tr("Island padding")
                from: 0
                to: 14
                stepSize: 1
                unit: " px"
            }
            CfgSlider {
                obj: root.bar.islands
                key: "spacing"
                label: Tr.tr("Gap between islands")
                from: 0
                to: 24
                stepSize: 1
                unit: " px"
            }
            CfgToggle {
                obj: root.bar.islands
                key: "radiusAuto"
                text: Tr.tr("Automatic radius")
            }
            CfgSlider {
                obj: root.bar.islands
                key: "radius"
                label: Tr.tr("Custom radius")
                enabled: !root.bar.islands.radiusAuto
                from: 0
                to: 24
                stepSize: 1
                unit: " px"
            }
            CfgSlider {
                obj: root.bar.islands
                key: "borderWidth"
                label: Tr.tr("Island border")
                from: 0
                to: 3
                stepSize: 0.5
                decimals: 1
                unit: " px"
            }
        }

        SectionHeader {
            text: Tr.tr("Clock")
        }

        RowGroup {
            CfgSelect {
                obj: root.bar
                key: "clockStyle"
                label: Tr.tr("Clock style")
                options: [
                    { text: Tr.tr("Default"), value: "default" },
                    { text: Tr.tr("Classic"), value: "classic" },
                    { text: Tr.tr("Badge"), value: "badge" },
                    { text: Tr.tr("Material"), value: "material" }
                ]
            }
        }

        SectionHeader {
            text: Tr.tr("Media face")
        }

        RowGroup {
            CfgSelect {
                obj: root.bar.mediaFace
                key: "infoMode"
                label: Tr.tr("Line under the title")
                options: [
                    { text: Tr.tr("Time (01:24 / 03:42)"), value: "duration" },
                    { text: Tr.tr("Artist"), value: "author" }
                ]
            }
            CfgSlider {
                obj: root.bar.mediaFace
                key: "width"
                label: Tr.tr("Title width")
                from: 80
                to: 280
                stepSize: 10
                unit: " px"
            }
            CfgToggle { obj: root.bar.mediaFace; key: "showIcon"; text: Tr.tr("Show the cover") }
            CfgToggle { obj: root.bar.mediaFace; key: "showControls"; text: Tr.tr("Show previous / play / next") }
            CfgToggle { obj: root.bar.mediaFace; key: "hideWhenIdle"; text: Tr.tr("Hide while nothing is playing") }
            CfgToggle { obj: root.bar.mediaFace; key: "liquid"; text: Tr.tr("Liquid progress"); subtext: Tr.tr("A liquid fills the widget as the song plays") }
            CfgSlider {
                obj: root.bar.mediaFace
                key: "liquidOpacity"
                label: Tr.tr("Liquid strength")
                enabled: root.bar.mediaFace.liquid
                from: 0.1
                to: 0.7
                stepSize: 0.02
                decimals: 2
            }
            CfgToggle { obj: root.bar.mediaFace; key: "replaceMedia"; text: Tr.tr("Use it for the Media and Media Player widgets too") }
        }

        SectionHeader {
            text: Tr.tr("Widget capsules")
        }

        RowGroup {
            CfgToggle {
                obj: root.bar.capsules
                key: "enable"
                text: Tr.tr("Widget capsules")
                subtext: Tr.tr("Give every widget its own pill")
            }
            CfgSelect {
                obj: root.bar.capsules
                key: "color"
                label: Tr.tr("Capsule colour")
                subtext: Tr.tr("What colour the widget pills are filled with")
                options: [
                    { text: Tr.tr("Default"), value: "default" },
                    { text: Tr.tr("Background"), value: "background" },
                    { text: Tr.tr("Surface"), value: "surface" },
                    { text: Tr.tr("Primary"), value: "primary" },
                    { text: Tr.tr("Secondary"), value: "secondary" },
                    { text: Tr.tr("Tertiary"), value: "tertiary" }
                ]
            }
            CfgSlider {
                obj: root.bar.capsules
                key: "thickness"
                label: Tr.tr("Capsule thickness")
                from: 0.5
                to: 1
                stepSize: 0.01
                decimals: 2
            }
            CfgToggle {
                obj: root.bar.capsules
                key: "radiusAuto"
                text: Tr.tr("Automatic radius")
                subtext: Tr.tr("Full pills. Turn off to set a fixed radius")
            }
            CfgSlider {
                obj: root.bar.capsules
                key: "radius"
                label: Tr.tr("Custom radius")
                enabled: !root.bar.capsules.radiusAuto
                from: 0
                to: 20
                stepSize: 1
                unit: " px"
            }
        }

        SectionHeader {
            text: Tr.tr("Widgets")
        }

        RowGroup {
            NavRow {
                icon: "view_week"
                text: Tr.tr("Widget layout")
                subtext: Tr.tr("Choose and order the widgets in each section")
                onClicked: root.nState.openSubPage(1)
            }
        }

        SectionHeader {
            text: Tr.tr("Workspaces")
        }

        RowGroup {
            CfgSelect {
                obj: root.bar.workspaces
                key: "theme"
                label: Tr.tr("Workspace style")
                options: [
                    { text: Tr.tr("Pills"), value: "pills" },
                    { text: Tr.tr("Numbers"), value: "numbers" },
                    { text: Tr.tr("Dots"), value: "dots" },
                    { text: Tr.tr("Pac-Man"), value: "pacman" },
                    { text: Tr.tr("Pills (new)"), value: "face-pills" },
                    { text: Tr.tr("Numbers (new)"), value: "face-numbers" },
                    { text: Tr.tr("Pac-Man (new)"), value: "face-pacman" }
                ]
            }
            CfgStepper {
                obj: root.bar.workspaces
                key: "shown"
                label: Tr.tr("Workspaces shown")
                subtext: Tr.tr("Higher-numbered workspaces are hidden unless active")
                from: 1
                to: 10
            }
            CfgToggle {
                obj: root.bar.workspaces
                key: "showAppIcons"
                text: Tr.tr("Show app icons")
            }
            CfgToggle {
                obj: root.bar.workspaces
                key: "monochromeIcons"
                text: Tr.tr("Monochrome icons")
            }
            CfgToggle {
                obj: root.bar.workspaces
                key: "alwaysShowNumbers"
                text: Tr.tr("Always show numbers")
            }
        }

        SectionHeader {
            text: Tr.tr("Indicators & resources")
        }

        RowGroup {
            CfgToggle {
                obj: root.bar.indicators.notifications
                key: "showUnreadCount"
                text: Tr.tr("Unread notification count")
            }
            CfgToggle {
                obj: root.bar.resources
                key: "alwaysShowCpu"
                text: Tr.tr("Always show CPU")
            }
            CfgToggle {
                obj: root.bar.resources
                key: "alwaysShowSwap"
                text: Tr.tr("Always show swap")
            }
            CfgSlider {
                obj: root.bar.resources
                key: "cpuWarningThreshold"
                label: Tr.tr("CPU warning at")
                from: 10
                to: 100
                stepSize: 5
                unit: "%"
            }
            CfgSlider {
                obj: root.bar.resources
                key: "memoryWarningThreshold"
                label: Tr.tr("Memory warning at")
                from: 10
                to: 100
                stepSize: 5
                unit: "%"
            }
            CfgSlider {
                obj: root.bar.resources
                key: "swapWarningThreshold"
                label: Tr.tr("Swap warning at")
                from: 10
                to: 100
                stepSize: 5
                unit: "%"
            }
        }

        SectionHeader {
            text: Tr.tr("Utility buttons")
        }

        RowGroup {
            CfgToggle { obj: root.bar.utilButtons; key: "showScreenSnip"; text: Tr.tr("Screen snip") }
            CfgToggle { obj: root.bar.utilButtons; key: "showColorPicker"; text: Tr.tr("Colour picker") }
            CfgToggle { obj: root.bar.utilButtons; key: "showMicToggle"; text: Tr.tr("Mic toggle") }
            CfgToggle { obj: root.bar.utilButtons; key: "showKeyboardToggle"; text: Tr.tr("Keyboard toggle") }
            CfgToggle { obj: root.bar.utilButtons; key: "showDarkModeToggle"; text: Tr.tr("Dark mode toggle") }
            CfgToggle { obj: root.bar.utilButtons; key: "showPerformanceProfileToggle"; text: Tr.tr("Performance profile toggle") }
            CfgToggle { obj: root.bar.utilButtons; key: "showScreenRecord"; text: Tr.tr("Screen record") }
        }
    }
}
