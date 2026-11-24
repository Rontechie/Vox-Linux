import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.settings.nexus
import qs.modules.common.widgets

NxPage {
    NxHeader { text: Translation.tr("Search & recognition") }
    NxGroup {
        NxNavRow {
            icon: "search"; text: Translation.tr("Search and music recognition"); subtext: Translation.tr("Search engine, music recognition")
            onClicked: NxNav.push(Translation.tr("Search"), "modules/settings/ServicesConfig.qml")
        }
    }

    NxHeader { text: Translation.tr("System monitor") }
    NxGroup {
        NxStepperRow {
            icon: "speed"; text: Translation.tr("Poll interval"); suffix: " ms"
            value: Config.options.resources.updateInterval; from: 500; to: 10000; step: 500
            onChanged: v => Config.options.resources.updateInterval = v
        }
        NxStepperRow {
            icon: "show_chart"; text: Translation.tr("History length"); suffix: " pts"
            value: Config.options.resources.historyLength; from: 10; to: 300; step: 10
            onChanged: v => Config.options.resources.historyLength = v
        }
    }

    NxHeader { text: Translation.tr("Weather") }
    NxGroup {
        NxToggleRow {
            icon: "partly_cloudy_day"; text: Translation.tr("Show weather in the bar")
            checked: Config.options.bar.weather.enable
            onToggled: v => Config.options.bar.weather.enable = v
        }
        NxStepperRow {
            icon: "update"; text: Translation.tr("Refresh every"); suffix: " min"
            value: Config.options.bar.weather.fetchInterval; from: 1; to: 120; step: 1
            onChanged: v => Config.options.bar.weather.fetchInterval = v
        }
    }
}
