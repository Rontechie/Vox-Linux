import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.desktopWidgets.ui
import qs.modules.desktopWidgets.widgets

ExprDesktopWidget {
    id: card
    wType: "media"
    baseW: 380
    baseH: 170

    face: Component {
        HwCard {
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: height
                    Loader {
                        anchors.fill: parent
                        sourceComponent: HwConfig.media.artStyle === "gear" ? gearArt : shapeArt
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 2

                    Item { Layout.fillHeight: true }
                    Text {
                        Layout.fillWidth: true
                        text: HwState.mediaTitle !== "" ? HwState.mediaTitle : HwState.tr("no_media_playing")
                        elide: Text.ElideRight
                        font.family: HwState.fontPrimary
                        font.pixelSize: Math.round(19 * HwState.fontScale)
                        font.weight: Font.Bold
                        color: HwPal.colorOnSurface
                    }
                    Text {
                        Layout.fillWidth: true
                        visible: HwState.mediaArtist !== ""
                        text: HwState.mediaArtist
                        elide: Text.ElideRight
                        font.family: HwState.fontSecondary
                        font.pixelSize: Math.round(13 * HwState.fontScale)
                        color: HwPal.muted
                    }
                    LyricFlip {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        visible: HwConfig.media.showLyric && HwState.mediaLyricsSynced
                        text: HwState.mediaLyricLine
                        color: HwM3.primary
                        fontSize: 14 * HwState.fontScale
                        weight: Font.DemiBold
                        align: Text.AlignLeft
                        maxLines: 2
                    }
                    Item { Layout.fillHeight: true }

                    RowLayout {
                        spacing: 10
                        HwIconButton { icon: "skip_previous"; onClicked: MprisController.previous() }
                        HwIconButton {
                            implicitWidth: 52
                            icon: HwState.mediaStatus === "Playing" ? "pause" : "play_arrow"
                            iconSize: 26
                            fill: HwM3.primary
                            ink: HwM3.c.m3onPrimary
                            onClicked: MprisController.togglePlaying()
                        }
                        HwIconButton { icon: "skip_next"; onClicked: MprisController.next() }
                    }
                }
            }
        }
    }

    Component {
        id: shapeArt
        ShapeArt {
            shape: HwConfig.media.shape
            artUrl: HwState.mediaArtUrl
            spinning: card.live && HwState.mediaStatus === "Playing"
        }
    }
    Component {
        id: gearArt
        MediaArtRing {
            artUrl: HwState.mediaArtUrl
            pct: HwState.mediaProgress
            running: card.live && HwState.mediaStatus === "Playing"
            ringColor: HwM3.primary
            fallbackColor: HwM3.secondaryContainer
            iconColor: HwM3.inkSecondaryContainer
        }
    }
}
