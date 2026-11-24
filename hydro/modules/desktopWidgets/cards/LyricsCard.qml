import QtQuick
import qs.modules.desktopWidgets.ui
import qs.modules.desktopWidgets.widgets
import qs.modules.lyrics

ExprDesktopWidget {
    id: card
    wType: "lyrics"
    baseW: 380
    baseH: 280

    face: Component {
        HwCard {
            LyricsScroller {
                anchors.fill: parent
                anchors.margins: 18
                visible: HwConfig.lyrics.theme === "classic"
                fontSize: 16 * HwState.fontScale
                align: HwConfig.lyrics.align === "center" ? Text.AlignHCenter : HwConfig.lyrics.align === "right" ? Text.AlignRight : Text.AlignLeft
            }
            PlayerLyrics {
                anchors.fill: parent
                anchors.margins: 18
                visible: HwConfig.lyrics.theme !== "classic"
                styleName: HwConfig.lyrics.theme
                textAlignment: HwConfig.lyrics.align === "center" ? Text.AlignHCenter : HwConfig.lyrics.align === "right" ? Text.AlignRight : Text.AlignLeft
            }
        }
    }
}
