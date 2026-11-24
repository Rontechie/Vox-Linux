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

    title: Tr.tr("Power & sound")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Battery")
        }

        RowGroup {
            CfgSlider {
                obj: root.opts.battery
                key: "low"
                label: Tr.tr("Low battery warning")
                from: 5
                to: 50
                stepSize: 1
                unit: "%"
            }
            CfgSlider {
                obj: root.opts.battery
                key: "critical"
                label: Tr.tr("Critical battery warning")
                from: 1
                to: 30
                stepSize: 1
                unit: "%"
            }
            CfgSlider {
                obj: root.opts.battery
                key: "full"
                label: Tr.tr("Battery full notice")
                from: 80
                to: 100
                stepSize: 1
                unit: "%"
            }
            CfgToggle {
                obj: root.opts.battery
                key: "automaticSuspend"
                text: Tr.tr("Suspend automatically")
                subtext: Tr.tr("When the battery gets very low")
            }
            CfgSlider {
                obj: root.opts.battery
                key: "suspend"
                label: Tr.tr("Suspend at")
                enabled: root.opts.battery.automaticSuspend
                from: 1
                to: 20
                stepSize: 1
                unit: "%"
            }
        }

        SectionHeader {
            text: Tr.tr("Night light")
        }

        RowGroup {
            CfgToggle {
                obj: root.opts.light.night
                key: "automatic"
                text: Tr.tr("Automatic night light")
            }
            CfgText {
                obj: root.opts.light.night
                key: "from"
                label: Tr.tr("From")
                subtext: Tr.tr("24-hour time, for example 19:00")
                smallField: true
            }
            CfgText {
                obj: root.opts.light.night
                key: "to"
                label: Tr.tr("To")
                subtext: Tr.tr("24-hour time, for example 06:30")
                smallField: true
            }
            CfgSlider {
                obj: root.opts.light.night
                key: "colorTemperature"
                label: Tr.tr("Colour temperature")
                from: 1000
                to: 6500
                stepSize: 100
                unit: " K"
            }
            CfgToggle {
                obj: root.opts.light.antiFlashbang
                key: "enable"
                text: Tr.tr("Anti-flashbang")
                subtext: Tr.tr("Dim bright windows")
            }
        }

        SectionHeader {
            text: Tr.tr("Sound")
        }

        RowGroup {
            CfgSelect {
                obj: root.opts.sounds
                key: "theme"
                label: Tr.tr("Sound theme")
                subtext: Tr.tr("A folder in /usr/share/sounds")
                options: [
                    {
                        text: "freedesktop",
                        value: "freedesktop"
                    },
                    {
                        text: "ocean",
                        value: "ocean"
                    },
                    {
                        text: "oxygen",
                        value: "oxygen"
                    }
                ]
            }
            CfgToggle {
                obj: root.opts.sounds
                key: "battery"
                text: Tr.tr("Battery sounds")
            }
            CfgToggle {
                obj: root.opts.sounds
                key: "pomodoro"
                text: Tr.tr("Pomodoro sounds")
            }
        }

        SectionHeader {
            text: Tr.tr("Volume protection")
        }

        RowGroup {
            CfgToggle {
                obj: root.opts.audio.protection
                key: "enable"
                text: Tr.tr("Protect against sudden loud sound")
            }
            CfgSlider {
                obj: root.opts.audio.protection
                key: "maxAllowedIncrease"
                label: Tr.tr("Largest allowed jump")
                enabled: root.opts.audio.protection.enable
                from: 1
                to: 50
                stepSize: 1
                unit: "%"
            }
            CfgSlider {
                obj: root.opts.audio.protection
                key: "maxAllowed"
                label: Tr.tr("Maximum volume")
                enabled: root.opts.audio.protection.enable
                from: 10
                to: 100
                stepSize: 1
                unit: "%"
            }
        }
    }
}
