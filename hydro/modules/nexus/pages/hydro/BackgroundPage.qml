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

    readonly property var bg: HC.Config.options.background
    readonly property var lock: HC.Config.options.lock
    readonly property var clock: HC.Config.options.background.widgets.clock

    title: Tr.tr("Background & lock")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SectionHeader {
            first: true
            text: Tr.tr("Wallpaper")
        }

        RowGroup {
            CfgToggle {
                obj: root.bg
                key: "hideWhenFullscreen"
                text: Tr.tr("Hide when a window is fullscreen")
            }
            CfgToggle {
                obj: root.bg.parallax
                key: "enableWorkspace"
                text: Tr.tr("Parallax: workspaces")
                subtext: Tr.tr("Move the wallpaper when you switch workspace")
            }
            CfgSlider {
                obj: root.bg.parallax
                key: "workspaceZoom"
                label: Tr.tr("Parallax zoom")
                from: 1
                to: 1.5
                stepSize: 0.01
                decimals: 2
                unit: "x"
            }
            CfgToggle {
                obj: root.bg.parallax
                key: "enableSidebar"
                text: Tr.tr("Parallax: sidebars")
            }
            CfgToggle {
                obj: root.bg.parallax
                key: "vertical"
                text: Tr.tr("Vertical parallax")
            }
        }

        SectionHeader {
            text: Tr.tr("Desktop widgets")
        }

        RowGroup {
            CfgToggle {
                obj: root.bg.widgets.weather
                key: "enable"
                text: Tr.tr("Weather")
            }
        }

        SectionHeader {
            text: Tr.tr("Clock")
        }

        RowGroup {
            CfgToggle {
                obj: root.clock
                key: "enable"
                text: Tr.tr("Clock")
            }
            CfgToggle {
                obj: root.clock
                key: "showOnlyWhenLocked"
                text: Tr.tr("Clock only when locked")
            }
            CfgSelect {
                obj: root.clock
                key: "style"
                label: Tr.tr("Clock style")
                options: [
                    { text: Tr.tr("Material"), value: "material" },
                    { text: Tr.tr("Cookie"), value: "cookie" },
                    { text: Tr.tr("Digital"), value: "digital" }
                ]
            }
            CfgSelect {
                obj: root.clock
                key: "styleLocked"
                label: Tr.tr("Clock style (locked)")
                options: [
                    { text: Tr.tr("Material"), value: "material" },
                    { text: Tr.tr("Cookie"), value: "cookie" },
                    { text: Tr.tr("Digital"), value: "digital" }
                ]
            }
            CfgSlider {
                obj: root.clock
                key: "widgetOpacity"
                label: Tr.tr("Opacity")
                from: 0.1
                to: 1
                stepSize: 0.05
                decimals: 2
            }
        }

        SectionHeader {
            text: Tr.tr("Clock placement")
        }

        RowGroup {
            CfgSelect {
                obj: root.clock
                key: "placementStrategy"
                label: Tr.tr("Placement")
                options: [
                    { text: Tr.tr("Free"), value: "free" },
                    { text: Tr.tr("Least busy area"), value: "leastBusy" },
                    { text: Tr.tr("Most busy area"), value: "mostBusy" }
                ]
            }
            CfgSlider {
                obj: root.clock
                key: "x"
                label: Tr.tr("Free position: X")
                from: 0
                to: 5000
                stepSize: 10
                unit: "px"
            }
            CfgSlider {
                obj: root.clock
                key: "y"
                label: Tr.tr("Free position: Y")
                from: 0
                to: 3000
                stepSize: 10
                unit: "px"
            }
            CfgSelect {
                obj: HwConfig.general
                key: "clockAnchor"
                label: Tr.tr("Free position: preset")
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
        }

        SectionHeader {
            text: Tr.tr("Clock shadow")
        }

        RowGroup {
            CfgToggle {
                obj: root.clock.shadow
                key: "enable"
                text: Tr.tr("Shadow")
            }
            CfgSlider {
                obj: root.clock.shadow
                key: "offset"
                label: Tr.tr("Shadow distance")
                from: 0
                to: 30
                stepSize: 1
                unit: "px"
            }
            CfgSlider {
                obj: root.clock.shadow
                key: "opacity"
                label: Tr.tr("Shadow strength")
                from: 0
                to: 1
                stepSize: 0.05
                decimals: 2
            }
        }

        SectionHeader {
            text: Tr.tr("Cookie clock: look")
        }

        RowGroup {
            CfgSlider {
                obj: root.clock.cookie
                key: "size"
                label: Tr.tr("Clock size")
                from: 120
                to: 600
                stepSize: 10
                unit: "px"
            }
            CfgStepper {
                obj: root.clock.cookie
                key: "sides"
                label: Tr.tr("Cookie sides")
                from: 3
                to: 30
            }
            CfgSelect {
                obj: root.clock.cookie
                key: "bodyColor"
                label: Tr.tr("Body colour")
                options: [
                    { text: Tr.tr("Secondary"), value: "secondaryContainer" },
                    { text: Tr.tr("Primary"), value: "primaryContainer" },
                    { text: Tr.tr("Tertiary"), value: "tertiaryContainer" },
                    { text: Tr.tr("Surface"), value: "surfaceContainer" }
                ]
            }
            CfgSlider {
                obj: root.clock.cookie
                key: "bodyOpacity"
                label: Tr.tr("Body opacity")
                from: 0.1
                to: 1
                stepSize: 0.05
                decimals: 2
            }
            CfgToggle {
                obj: root.clock.cookie
                key: "constantlyRotate"
                text: Tr.tr("Constantly rotate")
                subtext: Tr.tr("Expensive on weak GPUs")
            }
            CfgToggle {
                obj: root.clock.cookie
                key: "useSineCookie"
                text: Tr.tr("Sine-wave cookie")
                subtext: Tr.tr("The older cookie implementation")
            }
        }

        SectionHeader {
            text: Tr.tr("Cookie clock: dial & date")
        }

        RowGroup {
            CfgSelect {
                obj: root.clock.cookie
                key: "dialNumberStyle"
                label: Tr.tr("Dial")
                options: [
                    { text: Tr.tr("None"), value: "none" },
                    { text: Tr.tr("Dots"), value: "dots" },
                    { text: Tr.tr("Full ticks"), value: "full" },
                    { text: Tr.tr("Numbers"), value: "numbers" }
                ]
            }
            CfgToggle {
                obj: root.clock.cookie
                key: "hourMarks"
                text: Tr.tr("Hour marks")
                subtext: Tr.tr("Bold marks at the hours (dots / full dials)")
            }
            CfgToggle {
                obj: root.clock.cookie
                key: "timeIndicators"
                text: Tr.tr("Time digits")
                subtext: Tr.tr("Big hour and minute digits behind the hands")
            }
            CfgSelect {
                obj: root.clock.cookie
                key: "dateStyle"
                label: Tr.tr("Date style")
                options: [
                    { text: Tr.tr("Hidden"), value: "hide" },
                    { text: Tr.tr("Bubble"), value: "bubble" },
                    { text: Tr.tr("Border"), value: "border" },
                    { text: Tr.tr("Rect"), value: "rect" }
                ]
            }
            CfgToggle {
                obj: root.clock.cookie
                key: "dateInClock"
                text: Tr.tr("Date inside the clock")
                subtext: Tr.tr("Off puts the date as text under the clock")
            }
        }

        SectionHeader {
            text: Tr.tr("Cookie clock: hands")
        }

        RowGroup {
            CfgSelect {
                obj: root.clock.cookie
                key: "hourHandStyle"
                label: Tr.tr("Hour hand")
                options: [
                    { text: Tr.tr("Hidden"), value: "hide" },
                    { text: Tr.tr("Classic"), value: "classic" },
                    { text: Tr.tr("Hollow"), value: "hollow" },
                    { text: Tr.tr("Fill"), value: "fill" }
                ]
            }
            CfgSelect {
                obj: root.clock.cookie
                key: "minuteHandStyle"
                label: Tr.tr("Minute hand")
                options: [
                    { text: Tr.tr("Hidden"), value: "hide" },
                    { text: Tr.tr("Classic"), value: "classic" },
                    { text: Tr.tr("Thin"), value: "thin" },
                    { text: Tr.tr("Medium"), value: "medium" },
                    { text: Tr.tr("Bold"), value: "bold" }
                ]
            }
            CfgSelect {
                obj: root.clock.cookie
                key: "secondHandStyle"
                label: Tr.tr("Second hand")
                options: [
                    { text: Tr.tr("Hidden"), value: "hide" },
                    { text: Tr.tr("Classic"), value: "classic" },
                    { text: Tr.tr("Line"), value: "line" },
                    { text: Tr.tr("Dot"), value: "dot" }
                ]
            }
        }

        SectionHeader {
            text: Tr.tr("Digital clock")
        }

        RowGroup {
            CfgToggle {
                obj: root.clock.digital
                key: "showDate"
                text: Tr.tr("Show the date")
            }
            CfgToggle {
                obj: root.clock.digital
                key: "vertical"
                text: Tr.tr("Vertical layout")
                subtext: Tr.tr("Hours above minutes")
            }
            CfgToggle {
                obj: root.clock.digital
                key: "animateChange"
                text: Tr.tr("Animate changes")
            }
            CfgToggle {
                obj: root.clock.digital
                key: "adaptiveAlignment"
                text: Tr.tr("Adaptive alignment")
                subtext: Tr.tr("Align text toward the nearest screen edge")
            }
            CfgText {
                obj: root.clock.digital.font
                key: "family"
                label: Tr.tr("Font family")
            }
            CfgSlider {
                obj: root.clock.digital.font
                key: "size"
                label: Tr.tr("Font size")
                from: 20
                to: 400
                stepSize: 5
                unit: "px"
            }
            CfgSlider {
                obj: root.clock.digital.font
                key: "weight"
                label: Tr.tr("Font weight")
                from: 100
                to: 900
                stepSize: 10
            }
            CfgSlider {
                obj: root.clock.digital.font
                key: "width"
                label: Tr.tr("Font width")
                from: 25
                to: 151
                stepSize: 1
            }
            CfgSlider {
                obj: root.clock.digital.font
                key: "roundness"
                label: Tr.tr("Font roundness")
                from: 0
                to: 100
                stepSize: 1
            }
        }

        SectionHeader {
            text: Tr.tr("Clock quote")
        }

        RowGroup {
            CfgToggle {
                obj: root.clock.quote
                key: "enable"
                text: Tr.tr("Show a quote")
            }
            CfgText {
                obj: root.clock.quote
                key: "text"
                label: Tr.tr("Quote")
            }
        }

        SectionHeader {
            text: Tr.tr("Lock screen")
        }

        RowGroup {
            CfgSelect {
                obj: root.lock
                key: "style"
                label: Tr.tr("Lock screen style")
                subtext: Tr.tr("Iridium: gear / circle / digital clock, media and notification pills")
                options: [
                    { text: Tr.tr("Hydro"), value: "hydro" },
                    { text: Tr.tr("Iridium"), value: "iridium" }
                ]
            }
            CfgSelect {
                visible: root.lock.style === "iridium"
                obj: root.lock.iridium
                key: "clockStyle"
                label: Tr.tr("Iridium clock")
                subtext: Tr.tr("You can also right-click the clock on the lock screen")
                options: [
                    { text: Tr.tr("Gear"), value: "gear" },
                    { text: Tr.tr("Circle"), value: "circle" },
                    { text: Tr.tr("Stacked digits"), value: "digitalV" },
                    { text: Tr.tr("Side by side digits"), value: "digitalH" }
                ]
            }
            CfgToggle {
                visible: root.lock.style === "iridium"
                obj: root.lock.iridium
                key: "horizontal"
                text: Tr.tr("Iridium: clock beside the controls")
            }
            CfgToggle {
                visible: root.lock.style === "iridium"
                obj: root.lock.iridium
                key: "cavaEnabled"
                text: Tr.tr("Iridium: spectrum along the screen edge")
            }
        }

        RowGroup {
            CfgToggle {
                obj: root.lock
                key: "useHyprlock"
                text: Tr.tr("Use hyprlock")
            }
            CfgToggle {
                obj: root.lock
                key: "launchOnStartup"
                text: Tr.tr("Lock on startup")
            }
            CfgToggle {
                obj: root.lock
                key: "centerClock"
                text: Tr.tr("Centre the clock")
            }
            CfgToggle {
                obj: root.lock
                key: "showLockedText"
                text: Tr.tr("Show the locked text")
            }
            CfgToggle {
                obj: root.lock.blur
                key: "enable"
                text: Tr.tr("Blur the background")
            }
            CfgSlider {
                obj: root.lock.blur
                key: "radius"
                label: Tr.tr("Blur radius")
                from: 0
                to: 200
                stepSize: 5
            }
            CfgToggle {
                obj: root.lock.security
                key: "unlockKeyring"
                text: Tr.tr("Unlock the keyring on login")
            }
            CfgToggle {
                obj: root.lock.security
                key: "requirePasswordToPower"
                text: Tr.tr("Ask for the password to power off")
            }
        }

        SectionHeader {
            text: Tr.tr("Lock layout")
        }

        LockLayoutEditor {
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
        }

        RowGroup {
            CfgToggle {
                obj: root.lock.layout
                key: "snapToGrid"
                text: Tr.tr("Snap to grid")
            }
            CfgSlider {
                obj: root.lock.layout
                key: "gridSize"
                label: Tr.tr("Grid size")
                from: 5
                to: 100
                stepSize: 5
                unit: "px"
            }
            CfgToggle {
                obj: root.lock
                key: "minimalUntilInput"
                text: Tr.tr("Only clock and wallpaper until input")
            }
            CfgSelect {
                obj: root.lock.layout
                key: "mode"
                label: Tr.tr("Lock layout")
                options: [
                    { text: Tr.tr("Classic"), value: "classic" },
                    { text: Tr.tr("Dashboard (weather, media, resources, notifications)"), value: "dashboard" }
                ]
            }
            CfgSlider {
                obj: root.lock.layout
                key: "edgeMargin"
                label: Tr.tr("Screen edge margin")
                from: 0
                to: 300
                stepSize: 10
                unit: "px"
            }
        }

        SectionHeader {
            text: Tr.tr("Lock clock")
        }

        RowGroup {
            CfgToggle {
                obj: root.lock.layout.clock
                key: "enable"
                text: Tr.tr("Show the clock")
            }
            CfgSelect {
                obj: root.lock.layout.clock
                key: "style"
                label: Tr.tr("Clock style")
                options: [
                    { text: Tr.tr("Digital"), value: "digital" },
                    { text: Tr.tr("Stacked (two-tone)"), value: "stacked" },
                    { text: Tr.tr("Cookie"), value: "cookie" }
                ]
            }
            CfgSelect {
                obj: root.lock.layout.clock
                key: "anchor"
                label: Tr.tr("Position")
                options: [
                    { text: Tr.tr("Default"), value: "default" },
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
                obj: root.lock.layout.clock
                key: "x"
                label: Tr.tr("X (custom)")
                from: 0
                to: 4000
                stepSize: root.lock.layout.snapToGrid ? root.lock.layout.gridSize : 10
                unit: "px"
            }
            CfgSlider {
                obj: root.lock.layout.clock
                key: "y"
                label: Tr.tr("Y (custom)")
                from: 0
                to: 2500
                stepSize: root.lock.layout.snapToGrid ? root.lock.layout.gridSize : 10
                unit: "px"
            }
            CfgSlider {
                obj: root.lock.layout.clock
                key: "size"
                label: Tr.tr("Digital text size")
                from: 60
                to: 300
                stepSize: 4
                unit: "px"
            }
            CfgSlider {
                obj: root.lock.layout.clock
                key: "cookieSize"
                label: Tr.tr("Cookie clock size")
                from: 120
                to: 500
                stepSize: 10
                unit: "px"
            }
            CfgToggle {
                obj: root.lock.layout.clock
                key: "showDate"
                text: Tr.tr("Show the date")
            }
        }

        SectionHeader {
            text: Tr.tr("Lock profile card")
        }

        RowGroup {
            CfgSelect {
                obj: root.lock.layout.card
                key: "anchor"
                label: Tr.tr("Position")
                options: [
                    { text: Tr.tr("Default"), value: "default" },
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
                obj: root.lock.layout.card
                key: "x"
                label: Tr.tr("X (custom)")
                from: 0
                to: 4000
                stepSize: root.lock.layout.snapToGrid ? root.lock.layout.gridSize : 10
                unit: "px"
            }
            CfgSlider {
                obj: root.lock.layout.card
                key: "y"
                label: Tr.tr("Y (custom)")
                from: 0
                to: 2500
                stepSize: root.lock.layout.snapToGrid ? root.lock.layout.gridSize : 10
                unit: "px"
            }
            CfgSlider {
                obj: root.lock.layout.card
                key: "width"
                label: Tr.tr("Card width")
                from: 360
                to: 900
                stepSize: 10
                unit: "px"
            }
        }

        SectionHeader {
            text: Tr.tr("Lock power buttons")
        }

        RowGroup {
            CfgToggle {
                obj: root.lock.layout.power
                key: "enable"
                text: Tr.tr("Show sleep / restart / shut down")
            }
            CfgSelect {
                obj: root.lock.layout.power
                key: "anchor"
                label: Tr.tr("Position")
                options: [
                    { text: Tr.tr("Default"), value: "default" },
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
                obj: root.lock.layout.power
                key: "x"
                label: Tr.tr("X (custom)")
                from: 0
                to: 4000
                stepSize: root.lock.layout.snapToGrid ? root.lock.layout.gridSize : 10
                unit: "px"
            }
            CfgSlider {
                obj: root.lock.layout.power
                key: "y"
                label: Tr.tr("Y (custom)")
                from: 0
                to: 2500
                stepSize: root.lock.layout.snapToGrid ? root.lock.layout.gridSize : 10
                unit: "px"
            }
        }

        SectionHeader {
            text: Tr.tr("Lock battery chip")
        }

        RowGroup {
            CfgToggle {
                obj: root.lock.layout.battery
                key: "enable"
                text: Tr.tr("Show the battery")
            }
            CfgSelect {
                obj: root.lock.layout.battery
                key: "anchor"
                label: Tr.tr("Position")
                options: [
                    { text: Tr.tr("Default"), value: "default" },
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
                obj: root.lock.layout.battery
                key: "x"
                label: Tr.tr("X (custom)")
                from: 0
                to: 4000
                stepSize: root.lock.layout.snapToGrid ? root.lock.layout.gridSize : 10
                unit: "px"
            }
            CfgSlider {
                obj: root.lock.layout.battery
                key: "y"
                label: Tr.tr("Y (custom)")
                from: 0
                to: 2500
                stepSize: root.lock.layout.snapToGrid ? root.lock.layout.gridSize : 10
                unit: "px"
            }
        }
    }
}
