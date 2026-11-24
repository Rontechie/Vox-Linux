import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    NxGroup {
        NxToggleRow {
            icon: "counter_1"; text: Translation.tr("Unread count"); subtext: Translation.tr("Show the number of unread notifications instead of a dot")
            checked: Config.options.bar.indicators.notifications.showUnreadCount
            onToggled: v => Config.options.bar.indicators.notifications.showUnreadCount = v
        }
    }
}
