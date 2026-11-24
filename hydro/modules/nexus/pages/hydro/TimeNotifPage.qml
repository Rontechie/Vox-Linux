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

    title: Tr.tr("Time & notifications")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Clock & date")
        }

        RowGroup {
            CfgSelect {
                obj: root.opts.time
                key: "format"
                label: Tr.tr("Clock format")
                options: [
                    {
                        text: Tr.tr("24-hour"),
                        value: "hh:mm"
                    },
                    {
                        text: Tr.tr("12-hour"),
                        value: "h:mm AP"
                    }
                ]
            }
            CfgToggle {
                obj: root.opts.time
                key: "secondPrecision"
                text: Tr.tr("Show seconds")
            }
            CfgText {
                obj: root.opts.time
                key: "dateFormat"
                label: Tr.tr("Date format")
                subtext: Tr.tr("Qt format, for example ddd, dd/MM")
            }
            CfgText {
                obj: root.opts.time
                key: "shortDateFormat"
                label: Tr.tr("Short date format")
                smallField: true
            }
        }

        SectionHeader {
            text: Tr.tr("Pomodoro")
        }

        RowGroup {
            CfgSlider {
                obj: root.opts.time.pomodoro
                key: "focus"
                label: Tr.tr("Focus")
                from: 5
                to: 120
                stepSize: 5
                unit: " min"
            }
            CfgSlider {
                obj: root.opts.time.pomodoro
                key: "breakTime"
                label: Tr.tr("Break")
                from: 1
                to: 30
                stepSize: 1
                unit: " min"
            }
            CfgSlider {
                obj: root.opts.time.pomodoro
                key: "longBreak"
                label: Tr.tr("Long break")
                from: 5
                to: 60
                stepSize: 5
                unit: " min"
            }
            CfgStepper {
                obj: root.opts.time.pomodoro
                key: "cyclesBeforeLongBreak"
                label: Tr.tr("Cycles before a long break")
                from: 1
                to: 10
            }
        }

        SectionHeader {
            text: Tr.tr("Notifications & OSD")
        }

        RowGroup {
            CfgSlider {
                obj: root.opts.notifications
                key: "timeout"
                label: Tr.tr("Notification timeout")
                from: 1000
                to: 30000
                stepSize: 500
                unit: " ms"
            }
            CfgSelect {
                obj: root.opts.osd
                key: "style"
                label: Tr.tr("On-screen display style")
                options: [
                    { text: Tr.tr("Icon"), value: "icon" },
                    { text: Tr.tr("Dots"), value: "dots" },
                    { text: Tr.tr("Bubble"), value: "bubble" }
                ]
            }
            CfgSlider {
                obj: root.opts.osd
                key: "timeout"
                label: Tr.tr("On-screen display timeout")
                from: 500
                to: 10000
                stepSize: 100
                unit: " ms"
            }
            CfgToggle {
                obj: root.opts.conflictKiller
                key: "autoKillNotificationDaemons"
                text: Tr.tr("Stop other notification daemons")
                subtext: Tr.tr("So Hydro can show the notifications")
            }
            CfgToggle {
                obj: root.opts.conflictKiller
                key: "autoKillTrays"
                text: Tr.tr("Stop other system trays")
            }
        }

        SectionHeader {
            text: Tr.tr("Weather")
        }

        RowGroup {
            CfgToggle {
                obj: root.opts.bar.weather
                key: "enable"
                text: Tr.tr("Show weather")
            }
            CfgToggle {
                obj: root.opts.bar.weather
                key: "enableGPS"
                text: Tr.tr("Use GPS for the location")
            }
            CfgText {
                obj: root.opts.bar.weather
                key: "city"
                label: Tr.tr("City")
                subtext: Tr.tr("Used when GPS is off")
            }
            CfgToggle {
                obj: root.opts.bar.weather
                key: "useUSCS"
                text: Tr.tr("Use Fahrenheit and miles")
            }
            CfgSlider {
                obj: root.opts.bar.weather
                key: "fetchInterval"
                label: Tr.tr("Update every")
                from: 5
                to: 120
                stepSize: 5
                unit: " min"
            }
        }
    }
}
