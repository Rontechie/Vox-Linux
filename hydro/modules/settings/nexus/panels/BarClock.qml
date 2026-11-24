import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    NxGroup {
        NxToggleRow {
            icon: "today"; text: Translation.tr("Show date"); subtext: Translation.tr("Verbose bar: date next to the time")
            checked: Config.options.bar.verbose
            onToggled: v => Config.options.bar.verbose = v
        }
        NxToggleRow {
            icon: "timer"; text: Translation.tr("Show seconds"); subtext: Translation.tr("Updates the clock every second")
            checked: Config.options.time.secondPrecision
            onToggled: v => Config.options.time.secondPrecision = v
        }
        NxTextRow {
            icon: "schedule"; text: Translation.tr("Clock format"); placeholder: "hh:mm"
            value: Config.options.time.format
            onEdited: v => Config.options.time.format = v
        }
        NxTextRow {
            icon: "event"; text: Translation.tr("Short date format"); placeholder: "dd/MM"
            value: Config.options.time.shortDateFormat
            onEdited: v => Config.options.time.shortDateFormat = v
        }
    }
    StyledText {
        Layout.fillWidth: true; Layout.topMargin: 8; Layout.leftMargin: 8
        wrapMode: Text.WordWrap
        text: Translation.tr("Formats use Qt date patterns, for example hh:mm or ddd, dd/MM.")
        font.pixelSize: Appearance.font.pixelSize.smaller
        color: Appearance.m3colors.m3outline
    }
}
