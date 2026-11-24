import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    NxGroup {
        NxSelectRow {
            icon: "palette"; text: Translation.tr("Theme"); subtext: Translation.tr("How the workspace indicator looks")
            model: [
                { value: "pills", label: Translation.tr("Pills") },
                { value: "numbers", label: Translation.tr("Numbers") },
                { value: "dots", label: Translation.tr("Dots") },
                { value: "pacman", label: Translation.tr("Pac-Man") }
            ]
            current: Config.options.bar.workspaces.theme
            onPicked: v => Config.options.bar.workspaces.theme = v
        }
        NxToggleRow {
            visible: Config.options.bar.workspaces.theme === "pacman"
            icon: "pin"; text: Translation.tr("Numbers as pellets"); subtext: Translation.tr("Show the workspace numbers instead of the dots")
            checked: Config.options.bar.workspaces.pacmanNumbers
            onToggled: v => Config.options.bar.workspaces.pacmanNumbers = v
        }
        NxStepperRow {
            icon: "123"; text: Translation.tr("Workspaces shown")
            value: Config.options.bar.workspaces.shown; from: 1; to: 20; step: 1
            onChanged: v => Config.options.bar.workspaces.shown = v
        }
        NxToggleRow {
            icon: "apps"; text: Translation.tr("Show app icons"); subtext: Translation.tr("Show the icon of the window in each workspace")
            checked: Config.options.bar.workspaces.showAppIcons
            onToggled: v => Config.options.bar.workspaces.showAppIcons = v
        }
        NxToggleRow {
            icon: "contrast"; text: Translation.tr("Monochrome icons")
            checked: Config.options.bar.workspaces.monochromeIcons
            onToggled: v => Config.options.bar.workspaces.monochromeIcons = v
        }
        NxToggleRow {
            icon: "pin"; text: Translation.tr("Always show numbers")
            checked: Config.options.bar.workspaces.alwaysShowNumbers
            onToggled: v => Config.options.bar.workspaces.alwaysShowNumbers = v
        }
        NxToggleRow {
            icon: "text_fields"; text: Translation.tr("Use Nerd Font symbols")
            checked: Config.options.bar.workspaces.useNerdFont
            onToggled: v => Config.options.bar.workspaces.useNerdFont = v
        }
        NxStepperRow {
            icon: "timer"; text: Translation.tr("Number delay"); subtext: Translation.tr("How long to hold Super before numbers appear"); suffix: " ms"
            value: Config.options.bar.workspaces.showNumberDelay; from: 0; to: 2000; step: 50
            onChanged: v => Config.options.bar.workspaces.showNumberDelay = v
        }
    }
}
