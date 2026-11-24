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

    readonly property var opts: HC.Config.options

    title: Tr.tr("Dock & overview")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Dock")
        }

        RowGroup {
            CfgToggle {
                obj: root.opts.dock
                key: "enable"
                text: Tr.tr("Enable the dock")
            }
            CfgToggle {
                obj: root.opts.dock
                key: "hoverToReveal"
                text: Tr.tr("Reveal on hover")
            }
            CfgToggle {
                obj: root.opts.dock
                key: "pinnedOnStartup"
                text: Tr.tr("Pinned on startup")
            }
            CfgToggle {
                obj: root.opts.dock
                key: "monochromeIcons"
                text: Tr.tr("Monochrome icons")
            }
            CfgSlider {
                obj: root.opts.dock
                key: "height"
                label: Tr.tr("Dock height")
                from: 40
                to: 90
                stepSize: 1
                unit: " px"
            }
        }

        SectionHeader {
            text: Tr.tr("Overview")
        }

        RowGroup {
            CfgToggle {
                obj: root.opts.overview
                key: "enable"
                text: Tr.tr("Enable the overview")
            }
            CfgSlider {
                obj: root.opts.overview
                key: "scale"
                label: Tr.tr("Scale")
                from: 0.05
                to: 0.3
                stepSize: 0.01
                decimals: 2
            }
            CfgStepper {
                obj: root.opts.overview
                key: "rows"
                label: Tr.tr("Rows")
                from: 1
                to: 5
            }
            CfgStepper {
                obj: root.opts.overview
                key: "columns"
                label: Tr.tr("Columns")
                from: 1
                to: 8
            }
            CfgToggle {
                obj: root.opts.overview
                key: "centerIcons"
                text: Tr.tr("Centre window icons")
            }
            CfgToggle {
                obj: root.opts.overview
                key: "orderRightLeft"
                text: Tr.tr("Order right to left")
            }
            CfgToggle {
                obj: root.opts.overview
                key: "orderBottomUp"
                text: Tr.tr("Order bottom to top")
            }
        }

        SectionHeader {
            text: Tr.tr("Tray")
        }

        RowGroup {
            CfgToggle {
                obj: root.opts.tray
                key: "monochromeIcons"
                text: Tr.tr("Monochrome icons")
            }
            CfgToggle {
                obj: root.opts.tray
                key: "filterPassive"
                text: Tr.tr("Hide passive items")
            }
            CfgToggle {
                obj: root.opts.tray
                key: "invertPinnedItems"
                text: Tr.tr("Invert pinned items")
            }
            CfgToggle {
                obj: root.opts.tray
                key: "showItemId"
                text: Tr.tr("Show item IDs")
            }
        }

        SectionHeader {
            text: Tr.tr("Scrolling")
        }

        RowGroup {
            CfgToggle {
                obj: root.opts.interactions.scrolling
                key: "fasterTouchpadScroll"
                text: Tr.tr("Faster touchpad scrolling")
            }
            CfgSlider {
                obj: root.opts.interactions.scrolling
                key: "mouseScrollFactor"
                label: Tr.tr("Mouse wheel speed")
                from: 10
                to: 300
                stepSize: 10
            }
            CfgSlider {
                obj: root.opts.interactions.scrolling
                key: "touchpadScrollFactor"
                label: Tr.tr("Touchpad speed")
                from: 50
                to: 1000
                stepSize: 50
            }
        }
    }
}
