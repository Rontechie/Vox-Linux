import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.widgets.settings

ContentSection {
    icon: "calendar_month"
    title: Translation.tr("Date Format")

    SettingsDropdownRow {
        text: Translation.tr("Bar date")
        description: Translation.tr("Preset for the date shown in the bar")
        options: ["Mon, 17/11", "Mon, 11/17", "Mon 17 Nov", "17 Nov", "2026-11-17"]
        values: ["ddd, dd/MM", "ddd, MM/dd", "ddd d MMM", "d MMM", "yyyy-MM-dd"]
        currentValue: Config.options.time.dateFormat
        onValueChanged: v => Config.options.time.dateFormat = v
    }
    SettingsTextRow {
        text: Translation.tr("Custom bar format")
        monospace: true
        value: Config.options.time.dateFormat
        onValueCommitted: v => Config.options.time.dateFormat = v
    }
    SettingsTextRow {
        text: Translation.tr("Short date")
        monospace: true
        value: Config.options.time.shortDateFormat
        onValueCommitted: v => Config.options.time.shortDateFormat = v
    }
    SettingsTextRow {
        text: Translation.tr("Date with year")
        monospace: true
        value: Config.options.time.dateWithYearFormat
        onValueCommitted: v => Config.options.time.dateWithYearFormat = v
    }
    SettingsDivider {}
    StyledText {
        Layout.fillWidth: true
        Layout.leftMargin: SettingsTheme.spacingM
        Layout.rightMargin: SettingsTheme.spacingM
        wrapMode: Text.WordWrap
        font.family: Appearance.font.family.monospace
        font.pixelSize: SettingsTheme.fontSizeSmall
        color: SettingsTheme.surfaceVariantText
        lineHeight: 1.3
        text: "d / dd  day    ddd / dddd  day name\nM / MM  month    MMM / MMMM  month name\nyy / yyyy  year"
    }
}
