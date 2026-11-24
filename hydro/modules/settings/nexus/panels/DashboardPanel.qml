import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    NxHeader { text: Translation.tr("General") }
    NxGroup {
        NxToggleRow {
            icon: "memory"; text: Translation.tr("Keep loaded"); subtext: Translation.tr("Faster opening, uses a little more memory")
            checked: Config.options.sidebar.keepRightSidebarLoaded
            onToggled: v => Config.options.sidebar.keepRightSidebarLoaded = v
        }
    }

    NxHeader { text: Translation.tr("Quick sliders") }
    NxGroup {
        NxToggleRow {
            icon: "instant_mix"; text: Translation.tr("Show sliders")
            checked: Config.options.sidebar.quickSliders.enable
            onToggled: v => Config.options.sidebar.quickSliders.enable = v
        }
        NxToggleRow {
            visible: Config.options.sidebar.quickSliders.enable
            icon: "volume_up"; text: Translation.tr("Volume")
            checked: Config.options.sidebar.quickSliders.showVolume
            onToggled: v => Config.options.sidebar.quickSliders.showVolume = v
        }
        NxToggleRow {
            visible: Config.options.sidebar.quickSliders.enable
            icon: "mic"; text: Translation.tr("Microphone")
            checked: Config.options.sidebar.quickSliders.showMic
            onToggled: v => Config.options.sidebar.quickSliders.showMic = v
        }
        NxToggleRow {
            visible: Config.options.sidebar.quickSliders.enable
            icon: "brightness_6"; text: Translation.tr("Brightness")
            checked: Config.options.sidebar.quickSliders.showBrightness
            onToggled: v => Config.options.sidebar.quickSliders.showBrightness = v
        }
    }

    NxHeader { text: Translation.tr("Quick toggles") }
    NxGroup {
        NxSelectRow {
            icon: "toggle_on"; text: Translation.tr("Style")
            model: [{ value: "android", label: "Android" }, { value: "classic", label: Translation.tr("Classic") }]
            current: Config.options.sidebar.quickToggles.style
            onPicked: v => Config.options.sidebar.quickToggles.style = v
        }
        NxStepperRow {
            visible: Config.options.sidebar.quickToggles.style === "android"
            icon: "grid_view"; text: Translation.tr("Columns")
            value: Config.options.sidebar.quickToggles.android.columns; from: 2; to: 8; step: 1
            onChanged: v => Config.options.sidebar.quickToggles.android.columns = v
        }
    }
}
