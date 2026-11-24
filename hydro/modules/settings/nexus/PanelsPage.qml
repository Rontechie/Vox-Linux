import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.settings.nexus
import qs.modules.common.widgets

NxPage {
    NxHeader { text: Translation.tr("Bar") }
    NxGroup {
        NxToggleRow {
            icon: "vertical_align_bottom"; text: Translation.tr("Bar at the bottom")
            checked: Config.options.bar.bottom
            onToggled: v => Config.options.bar.bottom = v
        }
        NxSelectRow {
            icon: "dock_to_bottom"; text: Translation.tr("Bar style")
            model: [{ value: 0, label: Translation.tr("Hug") }, { value: 1, label: Translation.tr("Float") }, { value: 2, label: Translation.tr("Rectangle") }]
            current: Config.options.bar.cornerStyle
            onPicked: v => Config.options.bar.cornerStyle = v
        }
        NxToggleRow {
            icon: "view_sidebar"; text: Translation.tr("Vertical bar")
            checked: Config.options.bar.vertical
            onToggled: v => Config.options.bar.vertical = v
        }
        NxNavRow {
            icon: "tune"; text: Translation.tr("Bar layout and widgets"); subtext: Translation.tr("Shape, capsules, widget lanes")
            onClicked: NxNav.push(Translation.tr("Bar"), "modules/settings/hydro/HBarTab.qml")
        }
    }

    NxHeader { text: Translation.tr("Dock") }
    NxGroup {
        NxToggleRow {
            icon: "call_to_action"; text: Translation.tr("Dock")
            checked: Config.options.dock.enable
            onToggled: v => Config.options.dock.enable = v
        }
        NxToggleRow {
            visible: Config.options.dock.enable
            icon: "palette"; text: Translation.tr("Monochrome icons")
            checked: Config.options.dock.monochromeIcons
            onToggled: v => Config.options.dock.monochromeIcons = v
        }
        NxStepperRow {
            visible: Config.options.dock.enable
            icon: "height"; text: Translation.tr("Dock height"); suffix: " px"
            value: Config.options.dock.height; from: 40; to: 120; step: 2
            onChanged: v => Config.options.dock.height = v
        }
    }

    NxHeader { text: Translation.tr("More panels") }
    NxGroup {
        NxNavRow {
            icon: "toggle_on"; text: Translation.tr("Quick settings"); subtext: Translation.tr("Toggles, sliders, sidebars")
            onClicked: NxNav.push(Translation.tr("Quick settings"), "modules/settings/QuickConfig.qml")
        }
        NxNavRow {
            icon: "web_asset"; text: Translation.tr("Interface"); subtext: Translation.tr("Dock, lock screen, overview, corners")
            onClicked: NxNav.push(Translation.tr("Interface"), "modules/settings/InterfaceConfig.qml")
        }
        NxNavRow {
            icon: "view_quilt"; text: Translation.tr("Appearance details"); subtext: Translation.tr("Rounding, palette, fonts")
            onClicked: NxNav.push(Translation.tr("Appearance details"), "modules/settings/hydro/HAppearanceTab.qml")
        }
    }
}
