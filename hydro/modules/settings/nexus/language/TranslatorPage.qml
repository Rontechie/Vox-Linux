import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    NxHeader { text: Translation.tr("Translator") }
    NxGroup {
        NxTextRow {
            icon: "translate"; text: Translation.tr("Engine")
            subtext: Translation.tr("Run `trans -list-engines` to see options")
            value: Config.options.language.translator.engine; placeholder: "auto"
            onEdited: v => Config.options.language.translator.engine = v
        }
        NxTextRow {
            icon: "input"; text: Translation.tr("Source language")
            value: Config.options.language.translator.sourceLanguage; placeholder: "auto"
            onEdited: v => Config.options.language.translator.sourceLanguage = v
        }
        NxTextRow {
            icon: "output"; text: Translation.tr("Target language")
            subtext: Translation.tr("Run `trans -list-all` to see options")
            value: Config.options.language.translator.targetLanguage; placeholder: "auto"
            onEdited: v => Config.options.language.translator.targetLanguage = v
        }
    }
}
