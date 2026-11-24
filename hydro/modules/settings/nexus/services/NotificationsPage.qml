import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    NxHeader { text: Translation.tr("Popups") }
    NxGroup {
        NxStepperRow {
            icon: "timer"; text: Translation.tr("Popup timeout"); subtext: Translation.tr("Time before a popup is dismissed"); suffix: " ms"
            value: Config.options.notifications.timeout; from: 1000; to: 60000; step: 500
            onChanged: v => Config.options.notifications.timeout = v
        }
        NxToggleRow {
            icon: "monitor"; text: Translation.tr("Show on one monitor only")
            checked: Config.options.notifications.monitor.enable
            onToggled: v => Config.options.notifications.monitor.enable = v
        }
        NxTextRow {
            visible: Config.options.notifications.monitor.enable
            icon: "desktop_windows"; text: Translation.tr("Monitor name"); placeholder: "eDP-1"
            value: Config.options.notifications.monitor.name
            onEdited: v => Config.options.notifications.monitor.name = v
        }
    }
    NxHeader { text: Translation.tr("Other") }
    NxGroup {
        NxStepperRow {
            icon: "volume_up"; text: Translation.tr("Volume and brightness OSD timeout"); suffix: " ms"
            value: Config.options.osd.timeout; from: 200; to: 10000; step: 100
            onChanged: v => Config.options.osd.timeout = v
        }
        NxToggleRow {
            icon: "bluetooth"; text: Translation.tr("Bluetooth connections"); subtext: Translation.tr("Show the device and a connected or disconnected message beside the OSD")
            checked: Config.options.osd.bluetooth
            onToggled: v => Config.options.osd.bluetooth = v
        }
        NxToggleRow {
            icon: "counter_1"; text: Translation.tr("Unread count in the bar")
            checked: Config.options.bar.indicators.notifications.showUnreadCount
            onToggled: v => Config.options.bar.indicators.notifications.showUnreadCount = v
        }
    }
}
