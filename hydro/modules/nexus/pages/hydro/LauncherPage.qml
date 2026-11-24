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

    readonly property var cfg: HC.Config.options.launcher

    title: Tr.tr("Launcher")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Launcher style")
        }

        RowGroup {
            CfgSelect {
                obj: root.cfg
                key: "style"
                label: Tr.tr("Style")
                options: [
                    { text: Tr.tr("App grid"), value: "grid" },
                    { text: Tr.tr("Search pill"), value: "search" }
                ]
            }
            CfgSlider {
                obj: root.cfg.search
                key: "pillWidth"
                label: Tr.tr("Bar pill width")
                from: 110
                to: 320
                stepSize: 10
                unit: "px"
            }
            CfgSlider {
                obj: root.cfg.search
                key: "width"
                label: Tr.tr("Search pill width")
                from: 400
                to: 900
                stepSize: 10
                unit: "px"
            }
            CfgSlider {
                obj: root.cfg.search
                key: "rows"
                label: Tr.tr("Visible results")
                from: 3
                to: 12
                stepSize: 1
            }
            CfgToggle {
                obj: root.cfg.search
                key: "files"
                text: Tr.tr("Files mode")
                subtext: Tr.tr("Tab or the folder button switches between apps and files")
            }
        }

        SectionHeader {
            text: Tr.tr("Layout")
        }

        RowGroup {
            CfgSelect {
                obj: root.cfg
                key: "cols"
                label: Tr.tr("Grid columns")
                options: [
                    {
                        text: "4",
                        value: 0
                    },
                    {
                        text: "5",
                        value: 1
                    },
                    {
                        text: "6",
                        value: 2
                    }
                ]
            }
            CfgSelect {
                obj: root.cfg
                key: "iconSize"
                label: Tr.tr("Icon size")
                options: [
                    {
                        text: Tr.tr("Small"),
                        value: 0
                    },
                    {
                        text: Tr.tr("Medium"),
                        value: 1
                    },
                    {
                        text: Tr.tr("Large"),
                        value: 2
                    }
                ]
            }
            CfgSelect {
                obj: root.cfg
                key: "sizeIdx"
                label: Tr.tr("Launcher width")
                options: [
                    {
                        text: Tr.tr("Compact"),
                        value: 0
                    },
                    {
                        text: Tr.tr("Normal"),
                        value: 1
                    },
                    {
                        text: Tr.tr("Wide"),
                        value: 2
                    }
                ]
            }
            CfgToggle {
                obj: root.cfg
                key: "showLabels"
                text: Tr.tr("App names")
                subtext: Tr.tr("Show names under the icons")
            }
            CfgToggle {
                obj: root.cfg
                key: "showFavs"
                text: Tr.tr("Favourites")
                subtext: Tr.tr("The row of pinned apps")
            }
            CfgToggle {
                obj: root.cfg
                key: "showCats"
                text: Tr.tr("Categories")
                subtext: Tr.tr("Filter chips above the grid")
            }
            CfgToggle {
                obj: root.cfg
                key: "showPower"
                text: Tr.tr("Power bar")
                subtext: Tr.tr("Lock, sleep, restart, log out and shut down")
            }
            CfgToggle {
                obj: root.cfg
                key: "confirmPower"
                text: Tr.tr("Confirm power actions")
                subtext: Tr.tr("Ask before restart, log out and shut down")
            }
        }

        SectionHeader {
            text: Tr.tr("Look")
        }

        RowGroup {
            CfgSelect {
                obj: root.cfg
                key: "iconShape"
                label: Tr.tr("App icon shape")
                options: [
                    {
                        text: Tr.tr("Plain"),
                        value: 0
                    },
                    {
                        text: Tr.tr("Circle"),
                        value: 1
                    },
                    {
                        text: Tr.tr("Square"),
                        value: 2
                    },
                    {
                        text: Tr.tr("Cookie 9"),
                        value: 3
                    },
                    {
                        text: Tr.tr("Cookie 12"),
                        value: 4
                    },
                    {
                        text: Tr.tr("Sunny"),
                        value: 5
                    },
                    {
                        text: Tr.tr("Flower"),
                        value: 6
                    },
                    {
                        text: Tr.tr("Clover"),
                        value: 7
                    }
                ]
            }
            CfgToggle {
                obj: root.cfg
                key: "hoverMorph"
                text: Tr.tr("Hover morph")
                subtext: Tr.tr("Icon shapes turn into a spinning cookie on hover")
            }
        }

        SectionHeader {
            text: Tr.tr("Bar button")
        }

        RowGroup {
            CfgSelect {
                obj: root.cfg
                key: "panelIcon"
                label: Tr.tr("Button icon")
                subtext: Tr.tr("The button in the bar that opens the launcher")
                options: [
                    {
                        text: Tr.tr("Hydro logo"),
                        value: 9
                    },
                    {
                        text: Tr.tr("Apps"),
                        value: 0
                    },
                    {
                        text: Tr.tr("Menu"),
                        value: 1
                    },
                    {
                        text: Tr.tr("Home"),
                        value: 2
                    },
                    {
                        text: Tr.tr("Star"),
                        value: 3
                    },
                    {
                        text: Tr.tr("Heart"),
                        value: 4
                    },
                    {
                        text: Tr.tr("Widgets"),
                        value: 5
                    },
                    {
                        text: Tr.tr("Dashboard"),
                        value: 6
                    },
                    {
                        text: Tr.tr("Bolt"),
                        value: 7
                    },
                    {
                        text: Tr.tr("Leaf"),
                        value: 8
                    },
                    {
                        text: Tr.tr("Custom icon"),
                        value: 10
                    }
                ]
            }
            CfgText {
                obj: root.cfg
                key: "customIcon"
                label: Tr.tr("Custom icon")
                subtext: Tr.tr("An icon name, or the full path to a PNG or SVG")
                placeholderText: Tr.tr("Icon name or /path/to/image.png")
            }
        }
    }
}
