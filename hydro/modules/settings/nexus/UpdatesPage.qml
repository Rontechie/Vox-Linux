import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.widgets

NxPage {
    NxHeader { text: Translation.tr("Status") }
    NxGroup {
        NxInfoRow {
            icon: Updates.updateStronglyAdvised ? "priority_high" : Updates.count > 0 ? "update" : "check_circle"
            text: !Updates.available ? Translation.tr("Update checks unavailable on this system")
                : Updates.checking ? Translation.tr("Checking…")
                : Updates.count > 0 ? Translation.tr("%1 updates available").arg(Updates.count) : Translation.tr("Up to date")
            value: ""
        }
        NxButtonRow {
            icon: "refresh"; text: Translation.tr("Check now"); busy: Updates.checking
            disabled: !Updates.available || Updates.checking
            onClicked: Updates.refresh()
        }
        NxButtonRow {
            icon: "system_update_alt"; text: Translation.tr("Install updates"); subtext: Translation.tr("Opens a terminal and runs your update command")
            pill: Updates.count > 0 ? String(Updates.count) : ""; accent: true
            onClicked: Quickshell.execDetached(["bash", "-c", Config.options.apps.update])
        }
    }

    NxHeader { text: Translation.tr("Checking") }
    NxGroup {
        NxToggleRow {
            icon: "notifications_active"; text: Translation.tr("Check for updates automatically")
            checked: Config.options.updates.enableCheck
            onToggled: v => Config.options.updates.enableCheck = v
        }
        NxStepperRow {
            icon: "schedule"; text: Translation.tr("Check every"); suffix: " min"
            value: Config.options.updates.checkInterval; from: 10; to: 1440; step: 10
            onChanged: v => Config.options.updates.checkInterval = v
        }
        NxStepperRow {
            icon: "info"; text: Translation.tr("Suggest updating after"); suffix: " pkgs"
            value: Config.options.updates.adviseUpdateThreshold; from: 1; to: 1000; step: 5
            onChanged: v => Config.options.updates.adviseUpdateThreshold = v
        }
        NxStepperRow {
            icon: "warning"; text: Translation.tr("Strongly suggest after"); suffix: " pkgs"
            value: Config.options.updates.stronglyAdviseUpdateThreshold; from: 1; to: 2000; step: 10
            onChanged: v => Config.options.updates.stronglyAdviseUpdateThreshold = v
        }
    }
    NxHeader { text: Translation.tr("Command") }
    NxGroup {
        NxTextRow {
            wide: true; icon: "terminal"; text: Translation.tr("Update command")
            value: Config.options.apps.update
            onEdited: v => Config.options.apps.update = v
        }
    }
}
