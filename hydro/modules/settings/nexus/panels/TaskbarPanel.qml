import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    NxHeader { text: Translation.tr("Behaviour") }
    NxGroup {
        NxToggleRow {
            icon: "visibility_off"; text: Translation.tr("Auto-hide"); subtext: Translation.tr("Hide the bar until the cursor reaches its screen edge")
            checked: Config.options.bar.autoHide.enable
            onToggled: v => Config.options.bar.autoHide.enable = v
        }
        NxToggleRow {
            visible: Config.options.bar.autoHide.enable
            icon: "open_in_full"; text: Translation.tr("Push windows"); subtext: Translation.tr("Shrink windows instead of covering them when revealed")
            checked: Config.options.bar.autoHide.pushWindows
            onToggled: v => Config.options.bar.autoHide.pushWindows = v
        }
        NxStepperRow {
            visible: Config.options.bar.autoHide.enable
            icon: "ads_click"; text: Translation.tr("Hover region"); subtext: Translation.tr("Thickness of the edge that reveals the bar"); suffix: " px"
            value: Config.options.bar.autoHide.hoverRegionWidth; from: 1; to: 20; step: 1
            onChanged: v => Config.options.bar.autoHide.hoverRegionWidth = v
        }
        NxToggleRow {
            visible: Config.options.bar.autoHide.enable
            icon: "keyboard_command_key"; text: Translation.tr("Reveal while holding Super")
            checked: Config.options.bar.autoHide.showWhenPressingSuper.enable
            onToggled: v => Config.options.bar.autoHide.showWhenPressingSuper.enable = v
        }
        NxToggleRow {
            icon: "tooltip"; text: Translation.tr("Click to show popups"); subtext: Translation.tr("Open widget popups on click instead of hover")
            checked: Config.options.bar.tooltips.clickToShow
            onToggled: v => Config.options.bar.tooltips.clickToShow = v
        }
    }

    NxHeader { text: Translation.tr("Widgets") }
    NxGroup {
        NxNavRow {
            icon: "workspaces"; text: Translation.tr("Workspaces"); subtext: Translation.tr("Count, icons, numbers")
            onClicked: NxNav.push(Translation.tr("Workspaces"), "modules/settings/nexus/panels/BarWorkspaces.qml")
        }
        NxNavRow {
            icon: "schedule"; text: Translation.tr("Clock"); subtext: Translation.tr("Format and seconds")
            onClicked: NxNav.push(Translation.tr("Clock"), "modules/settings/nexus/panels/BarClock.qml")
        }
        NxNavRow {
            icon: "apps"; text: Translation.tr("System tray"); subtext: Translation.tr("Icons and filtering")
            onClicked: NxNav.push(Translation.tr("System tray"), "modules/settings/nexus/panels/BarTray.qml")
        }
        NxNavRow {
            icon: "notifications"; text: Translation.tr("Status icons"); subtext: Translation.tr("Notification indicator")
            onClicked: NxNav.push(Translation.tr("Status icons"), "modules/settings/nexus/panels/BarStatusIcons.qml")
        }
    }

    NxHeader { text: Translation.tr("Layout") }
    NxGroup {
        NxNavRow {
            icon: "tune"; text: Translation.tr("Bar layout and widgets"); subtext: Translation.tr("Shape, capsules, widget lanes")
            onClicked: NxNav.push(Translation.tr("Bar"), "modules/settings/hydro/HBarTab.qml")
        }
    }
}
