import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    NxHeader { text: Translation.tr("Sidebar") }
    NxGroup {
        NxToggleRow {
            icon: "translate"; text: Translation.tr("Translator"); subtext: Translation.tr("Translate text as you type")
            checked: Config.options.sidebar.translator.enable
            onToggled: v => Config.options.sidebar.translator.enable = v
        }
        NxStepperRow {
            visible: Config.options.sidebar.translator.enable
            icon: "hourglass_top"; text: Translation.tr("Translation delay"); subtext: Translation.tr("Wait before sending a request"); suffix: " ms"
            value: Config.options.sidebar.translator.delay; from: 0; to: 2000; step: 50
            onChanged: v => Config.options.sidebar.translator.delay = v
        }
    }
}
