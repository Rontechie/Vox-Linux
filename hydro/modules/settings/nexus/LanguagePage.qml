import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

NxPage {
    NxHeader { text: Translation.tr("Language") }
    NxGroup {
        NxSelectRow {
            icon: "language"; text: Translation.tr("Interface language"); subtext: Translation.tr("Restart the shell after changing")
            model: [{ value: "auto", label: Translation.tr("Auto (system)") }, ...Translation.allAvailableLanguages.map(l => ({ value: l, label: l }))]
            current: Config.options.language.ui
            onPicked: v => Config.options.language.ui = v
        }
    }

    NxHeader { text: Translation.tr("Weather location & units") }
    NxGroup {
        NxToggleRow {
            icon: "my_location"; text: Translation.tr("Locate automatically"); subtext: Translation.tr("Use GPS / IP instead of a city")
            checked: Config.options.bar.weather.enableGPS
            onToggled: v => Config.options.bar.weather.enableGPS = v
        }
        NxTextRow {
            visible: !Config.options.bar.weather.enableGPS
            icon: "location_city"; text: Translation.tr("City")
            value: Config.options.bar.weather.city; placeholder: "e.g. Singapore"
            onEdited: v => Config.options.bar.weather.city = v
        }
        NxToggleRow {
            icon: "thermostat"; text: Translation.tr("Imperial units"); subtext: Translation.tr("°F and mph instead of °C and km/h")
            checked: Config.options.bar.weather.useUSCS
            onToggled: v => Config.options.bar.weather.useUSCS = v
        }
    }

    NxHeader { text: Translation.tr("Time & date") }
    NxGroup {
        NxTextRow { icon: "schedule"; text: Translation.tr("Clock format"); value: Config.options.time.format; onEdited: v => Config.options.time.format = v }
        NxTextRow { icon: "today"; text: Translation.tr("Date format"); value: Config.options.time.dateFormat; onEdited: v => Config.options.time.dateFormat = v }
        NxTextRow { icon: "event"; text: Translation.tr("Short date"); value: Config.options.time.shortDateFormat; onEdited: v => Config.options.time.shortDateFormat = v }
    }
    StyledText {
        Layout.fillWidth: true; Layout.topMargin: 8; Layout.leftMargin: 8
        wrapMode: Text.WordWrap
        text: Translation.tr("Formats use Qt date patterns, for example hh:mm or ddd, dd/MM.")
        font.pixelSize: Appearance.font.pixelSize.smaller
        color: Appearance.m3colors.m3outline
    }
}
