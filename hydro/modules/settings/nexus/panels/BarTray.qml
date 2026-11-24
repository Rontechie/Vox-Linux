import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    NxGroup {
        NxToggleRow {
            icon: "contrast"; text: Translation.tr("Monochrome icons")
            checked: Config.options.tray.monochromeIcons
            onToggled: v => Config.options.tray.monochromeIcons = v
        }
        NxToggleRow {
            icon: "filter_alt"; text: Translation.tr("Hide passive items"); subtext: Translation.tr("Skip tray items that report themselves as passive")
            checked: Config.options.tray.filterPassive
            onToggled: v => Config.options.tray.filterPassive = v
        }
        NxToggleRow {
            icon: "badge"; text: Translation.tr("Show item ids"); subtext: Translation.tr("Useful for filling the pinned list")
            checked: Config.options.tray.showItemId
            onToggled: v => Config.options.tray.showItemId = v
        }
        NxToggleRow {
            icon: "swap_horiz"; text: Translation.tr("Pinned list is a whitelist"); subtext: Translation.tr("Pinned items stay in the tray, the rest go to the overflow")
            checked: Config.options.tray.invertPinnedItems
            onToggled: v => Config.options.tray.invertPinnedItems = v
        }
    }
}
