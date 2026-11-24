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

    readonly property var look: HC.Config.options.appearance

    title: Tr.tr("Colours")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Colour scheme")
        }

        RowGroup {
            CfgSelect {
                obj: root.look.palette
                key: "type"
                label: Tr.tr("Scheme type")
                subtext: Tr.tr("How colours are generated from the wallpaper")
                options: ["auto", "scheme-content", "scheme-expressive", "scheme-fidelity", "scheme-fruit-salad", "scheme-monochrome", "scheme-neutral", "scheme-rainbow", "scheme-tonal-spot"].map(t => ({
                            text: t === "auto" ? Tr.tr("Auto") : t.replace("scheme-", "").replace(/-/g, " "),
                            value: t
                        }))
            }
            CfgToggle {
                obj: root.look
                key: "extraBackgroundTint"
                text: Tr.tr("Extra background tint")
            }
        }

        SectionHeader {
            text: Tr.tr("Apply the wallpaper colours to")
        }

        RowGroup {
            CfgToggle {
                obj: root.look.wallpaperTheming
                key: "enableAppsAndShell"
                text: Tr.tr("Apps and shell")
            }
            CfgToggle {
                obj: root.look.wallpaperTheming
                key: "enableQtApps"
                text: Tr.tr("Qt apps")
            }
            CfgToggle {
                obj: root.look.wallpaperTheming
                key: "enableTerminal"
                text: Tr.tr("Terminal")
            }
        }

        SectionHeader {
            text: Tr.tr("Terminal colours")
        }

        RowGroup {
            CfgSlider {
                obj: root.look.wallpaperTheming.terminalGenerationProps
                key: "harmony"
                label: Tr.tr("Harmony")
                from: 0
                to: 1
                stepSize: 0.05
                decimals: 2
            }
            CfgSlider {
                obj: root.look.wallpaperTheming.terminalGenerationProps
                key: "harmonizeThreshold"
                label: Tr.tr("Harmonize threshold")
                from: 0
                to: 100
                stepSize: 5
            }
            CfgSlider {
                obj: root.look.wallpaperTheming.terminalGenerationProps
                key: "termFgBoost"
                label: Tr.tr("Foreground boost")
                from: 0
                to: 1
                stepSize: 0.05
                decimals: 2
            }
            CfgToggle {
                obj: root.look.wallpaperTheming.terminalGenerationProps
                key: "forceDarkMode"
                text: Tr.tr("Always use dark terminal colours")
            }
        }

        SectionHeader {
            text: Tr.tr("Transparency")
        }

        RowGroup {
            CfgToggle {
                obj: root.look.transparency
                key: "enable"
                text: Tr.tr("Transparency")
            }
            CfgToggle {
                obj: root.look.transparency
                key: "automatic"
                text: Tr.tr("Automatic")
                subtext: Tr.tr("Pick the amount from the wallpaper")
            }
            CfgSlider {
                obj: root.look.transparency
                key: "backgroundTransparency"
                label: Tr.tr("Background transparency")
                enabled: !root.look.transparency.automatic
                from: 0
                to: 1
                stepSize: 0.01
                decimals: 2
            }
            CfgSlider {
                obj: root.look.transparency
                key: "contentTransparency"
                label: Tr.tr("Content transparency")
                enabled: !root.look.transparency.automatic
                from: 0
                to: 1
                stepSize: 0.01
                decimals: 2
            }
        }

        SectionHeader {
            text: Tr.tr("Screen")
        }

        RowGroup {
            CfgSelect {
                obj: root.look
                key: "fakeScreenRounding"
                label: Tr.tr("Fake screen rounding")
                subtext: Tr.tr("Round the screen corners")
                options: [
                    {
                        text: Tr.tr("Off"),
                        value: 0
                    },
                    {
                        text: Tr.tr("Always"),
                        value: 1
                    },
                    {
                        text: Tr.tr("When not fullscreen"),
                        value: 2
                    }
                ]
            }
        }

        SectionHeader {
            text: Tr.tr("Roundness")
        }

        RowGroup {
            CfgSlider {
                obj: root.look
                key: "roundness"
                label: Tr.tr("UI roundness")
                subtext: Tr.tr("How round corners are across the shell; 0 is square")
                from: 0
                to: 2
                stepSize: 0.05
                decimals: 2
                unit: "x"
            }
        }
    }
}
