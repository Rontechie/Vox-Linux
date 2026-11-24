import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    NxHeader { text: Translation.tr("Overview") }
    NxGroup {
        NxToggleRow {
            icon: "dashboard"; text: Translation.tr("Enabled")
            checked: Config.options.overview.enable
            onToggled: v => Config.options.overview.enable = v
        }
        NxSliderRow {
            visible: Config.options.overview.enable
            icon: "zoom_in"; label: Translation.tr("Window scale")
            valueLabel: Math.round(Config.options.overview.scale * 100) + "%"
            value: Config.options.overview.scale; from: 0.05; to: 0.4
            onMoved: v => Config.options.overview.scale = Math.round(v * 100) / 100
        }
        NxStepperRow {
            visible: Config.options.overview.enable
            icon: "table_rows"; text: Translation.tr("Rows")
            value: Config.options.overview.rows; from: 1; to: 6; step: 1
            onChanged: v => Config.options.overview.rows = v
        }
        NxStepperRow {
            visible: Config.options.overview.enable
            icon: "view_column"; text: Translation.tr("Columns")
            value: Config.options.overview.columns; from: 1; to: 10; step: 1
            onChanged: v => Config.options.overview.columns = v
        }
        NxToggleRow {
            visible: Config.options.overview.enable
            icon: "format_textdirection_r_to_l"; text: Translation.tr("Order right to left")
            checked: Config.options.overview.orderRightLeft
            onToggled: v => Config.options.overview.orderRightLeft = v
        }
        NxToggleRow {
            visible: Config.options.overview.enable
            icon: "vertical_align_top"; text: Translation.tr("Order bottom up")
            checked: Config.options.overview.orderBottomUp
            onToggled: v => Config.options.overview.orderBottomUp = v
        }
        NxToggleRow {
            visible: Config.options.overview.enable
            icon: "center_focus_strong"; text: Translation.tr("Centre icons")
            checked: Config.options.overview.centerIcons
            onToggled: v => Config.options.overview.centerIcons = v
        }
    }

    NxHeader { text: Translation.tr("Search") }
    NxGroup {
        NxToggleRow {
            icon: "manage_search"; text: Translation.tr("Actions without prefix"); subtext: Translation.tr("Show default actions when no prefix is typed")
            checked: Config.options.search.prefix.showDefaultActionsWithoutPrefix
            onToggled: v => Config.options.search.prefix.showDefaultActionsWithoutPrefix = v
        }
        NxToggleRow {
            icon: "science"; text: Translation.tr("Sloppy search"); subtext: Translation.tr("Score by Levenshtein distance instead of fuzzy matching")
            checked: Config.options.search.sloppy
            onToggled: v => Config.options.search.sloppy = v
        }
        NxStepperRow {
            icon: "hourglass_top"; text: Translation.tr("Non-app result delay"); subtext: Translation.tr("Prevents lag while typing"); suffix: " ms"
            value: Config.options.search.nonAppResultDelay; from: 0; to: 500; step: 10
            onChanged: v => Config.options.search.nonAppResultDelay = v
        }
        NxTextRow {
            wide: true; icon: "travel_explore"; text: Translation.tr("Web search URL")
            value: Config.options.search.engineBaseUrl
            onEdited: v => Config.options.search.engineBaseUrl = v
        }
    }

    NxHeader { text: Translation.tr("Prefixes") }
    NxGroup {
        NxTextRow { icon: "bolt"; text: Translation.tr("Actions"); value: Config.options.search.prefix.action; onEdited: v => Config.options.search.prefix.action = v }
        NxTextRow { icon: "apps"; text: Translation.tr("Apps"); value: Config.options.search.prefix.app; onEdited: v => Config.options.search.prefix.app = v }
        NxTextRow { icon: "content_paste"; text: Translation.tr("Clipboard"); value: Config.options.search.prefix.clipboard; onEdited: v => Config.options.search.prefix.clipboard = v }
        NxTextRow { icon: "mood"; text: Translation.tr("Emojis"); value: Config.options.search.prefix.emojis; onEdited: v => Config.options.search.prefix.emojis = v }
        NxTextRow { icon: "calculate"; text: Translation.tr("Math"); value: Config.options.search.prefix.math; onEdited: v => Config.options.search.prefix.math = v }
        NxTextRow { icon: "terminal"; text: Translation.tr("Shell command"); value: Config.options.search.prefix.shellCommand; onEdited: v => Config.options.search.prefix.shellCommand = v }
        NxTextRow { icon: "public"; text: Translation.tr("Web search"); value: Config.options.search.prefix.webSearch; onEdited: v => Config.options.search.prefix.webSearch = v }
    }
}
