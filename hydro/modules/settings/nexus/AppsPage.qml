import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

NxPage {
    NxHeader { text: Translation.tr("Commands the shell runs") }
    NxGroup {
        NxTextRow { wide: true; icon: "terminal"; text: Translation.tr("Terminal"); value: Config.options.apps.terminal; onEdited: v => Config.options.apps.terminal = v }
        NxTextRow { wide: true; icon: "monitoring"; text: Translation.tr("Task manager"); value: Config.options.apps.taskManager; onEdited: v => Config.options.apps.taskManager = v }
        NxTextRow { wide: true; icon: "tune"; text: Translation.tr("Volume mixer"); value: Config.options.apps.volumeMixer; onEdited: v => Config.options.apps.volumeMixer = v }
        NxTextRow { wide: true; icon: "wifi"; text: Translation.tr("Network settings"); value: Config.options.apps.network; onEdited: v => Config.options.apps.network = v }
        NxTextRow { wide: true; icon: "settings_ethernet"; text: Translation.tr("Ethernet settings"); value: Config.options.apps.networkEthernet; onEdited: v => Config.options.apps.networkEthernet = v }
        NxTextRow { wide: true; icon: "bluetooth"; text: Translation.tr("Bluetooth settings"); value: Config.options.apps.bluetooth; onEdited: v => Config.options.apps.bluetooth = v }
    }
    NxHeader { text: Translation.tr("Account") }
    NxGroup {
        NxTextRow { wide: true; icon: "manage_accounts"; text: Translation.tr("Manage user"); value: Config.options.apps.manageUser; onEdited: v => Config.options.apps.manageUser = v }
        NxTextRow { wide: true; icon: "password"; text: Translation.tr("Change password"); value: Config.options.apps.changePassword; onEdited: v => Config.options.apps.changePassword = v }
    }
}
