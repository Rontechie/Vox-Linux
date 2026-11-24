import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.widgets.settings

ContentSection {
    icon: "weather_mix"
    title: Translation.tr("Weather")

    SettingsToggleRow {
        text: Translation.tr("Enable weather")
        checked: Config.options.bar.weather.enable
        onToggled: c => Config.options.bar.weather.enable = c
    }
    SettingsToggleRow {
        text: Translation.tr("Use imperial units")
        description: Translation.tr("°F and mph instead of °C and km/h")
        checked: Config.options.bar.weather.useUSCS
        onToggled: c => Config.options.bar.weather.useUSCS = c
    }
    SettingsDivider {}
    SettingsToggleRow {
        text: Translation.tr("Auto location")
        description: Translation.tr("Find where you are automatically")
        checked: Config.options.bar.weather.enableGPS
        onToggled: c => Config.options.bar.weather.enableGPS = c
    }
    SettingsTextRow {
        visible: !Config.options.bar.weather.enableGPS
        text: Translation.tr("City")
        placeholderText: Translation.tr("e.g. Singapore")
        value: Config.options.bar.weather.city
        onValueCommitted: v => Config.options.bar.weather.city = v
    }
    SettingsSliderRow {
        text: Translation.tr("Refresh every")
        from: 1
        to: 60
        stepSize: 1
        unit: " min"
        value: Config.options.bar.weather.fetchInterval
        onSliderValueChanged: v => Config.options.bar.weather.fetchInterval = Math.round(v)
    }
}
