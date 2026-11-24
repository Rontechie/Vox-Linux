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

    readonly property var sidebar: HC.Config.options.sidebar

    title: Tr.tr("Dashboard & sidebar")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Dashboard")
        }

        RowGroup {
            CfgToggle {
                obj: root.sidebar
                key: "keepRightSidebarLoaded"
                text: Tr.tr("Keep loaded")
                subtext: Tr.tr("Opens instantly, but uses a little more memory")
            }
            CfgSelect {
                obj: root.sidebar.quickToggles
                key: "style"
                label: Tr.tr("Quick toggles style")
                options: [
                    {
                        text: Tr.tr("Android"),
                        value: "android"
                    },
                    {
                        text: Tr.tr("Classic"),
                        value: "classic"
                    }
                ]
            }
            CfgStepper {
                obj: root.sidebar.quickToggles.android
                key: "columns"
                label: Tr.tr("Toggle columns")
                from: 2
                to: 8
            }
        }

        SectionHeader {
            text: Tr.tr("Quick sliders")
        }

        RowGroup {
            CfgToggle {
                obj: root.sidebar.quickSliders
                key: "enable"
                text: Tr.tr("Show quick sliders")
            }
            CfgToggle {
                obj: root.sidebar.quickSliders
                key: "showVolume"
                text: Tr.tr("Volume")
            }
            CfgToggle {
                obj: root.sidebar.quickSliders
                key: "showMic"
                text: Tr.tr("Microphone")
            }
            CfgToggle {
                obj: root.sidebar.quickSliders
                key: "showBrightness"
                text: Tr.tr("Brightness")
            }
        }

        SectionHeader {
            text: Tr.tr("Sidebar tools")
        }

        RowGroup {
            CfgToggle {
                obj: root.sidebar.translator
                key: "enable"
                text: Tr.tr("Translator")
            }
            CfgToggle {
                obj: root.sidebar.booru
                key: "allowNsfw"
                text: Tr.tr("Allow NSFW images")
            }
        }

        SectionHeader {
            text: Tr.tr("Screen corners")
        }

        RowGroup {
            CfgToggle {
                obj: root.sidebar.cornerOpen
                key: "enable"
                text: Tr.tr("Open sidebars from screen corners")
            }
            CfgToggle {
                obj: root.sidebar.cornerOpen
                key: "bottom"
                text: Tr.tr("Use the bottom corners")
            }
            CfgToggle {
                obj: root.sidebar.cornerOpen
                key: "valueScroll"
                text: Tr.tr("Scroll in a corner to change volume/brightness")
            }
            CfgToggle {
                obj: root.sidebar.cornerOpen
                key: "clickless"
                text: Tr.tr("Open without clicking")
            }
            CfgToggle {
                obj: root.sidebar.cornerOpen
                key: "visualize"
                text: Tr.tr("Show the corner regions")
            }
        }
    }
}
