import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.widgets.settings

ContentSection {
    id: sec
    icon: "text_fields"
    title: Translation.tr("Typography")

    readonly property var families: {
        const f = Qt.fontFamilies().slice().sort((a, b) => a.localeCompare(b))
        return f
    }

    SettingsDropdownRow {
        text: Translation.tr("Normal font")
        options: sec.families
        currentValue: Config.options.appearance.fonts.main
        onValueChanged: v => Config.options.appearance.fonts.main = v
    }
    SettingsDropdownRow {
        text: Translation.tr("Title font")
        options: sec.families
        currentValue: Config.options.appearance.fonts.title
        onValueChanged: v => Config.options.appearance.fonts.title = v
    }
    SettingsDropdownRow {
        text: Translation.tr("Monospace font")
        options: sec.families
        currentValue: Config.options.appearance.fonts.monospace
        onValueChanged: v => Config.options.appearance.fonts.monospace = v
    }
    SettingsDropdownRow {
        text: Translation.tr("Numbers font")
        options: sec.families
        currentValue: Config.options.appearance.fonts.numbers
        onValueChanged: v => Config.options.appearance.fonts.numbers = v
    }
}
