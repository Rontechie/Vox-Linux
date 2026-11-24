import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    function nativeName(code) {
        const l = Qt.locale(code);
        return l.name === "C" ? code : (l.nativeLanguageName || l.name);
    }
    readonly property string selected: Config.options.language.ui

    NxGroup {
        NxButtonRow {
            icon: "auto_mode"; text: Translation.tr("Auto (system)")
            pill: page.selected === "auto" ? Translation.tr("In use") : ""
            accent: page.selected === "auto"
            onClicked: Config.options.language.ui = "auto"
        }
        Repeater {
            model: Translation.allAvailableLanguages
            NxButtonRow {
                required property string modelData
                icon: "language"; text: page.nativeName(modelData); subtext: modelData
                pill: page.selected === modelData ? Translation.tr("In use") : ""
                accent: page.selected === modelData
                onClicked: Config.options.language.ui = modelData
            }
        }
    }
    StyledText {
        Layout.fillWidth: true; Layout.topMargin: 8; Layout.leftMargin: 8
        wrapMode: Text.WordWrap
        text: Translation.tr("Restart the shell after changing the language.")
        font.pixelSize: Appearance.font.pixelSize.smaller
        color: Appearance.m3colors.m3outline
    }
}
