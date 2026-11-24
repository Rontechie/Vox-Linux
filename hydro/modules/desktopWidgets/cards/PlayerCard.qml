import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common.widgets
import qs.modules.desktopWidgets.ui
import qs.modules.desktopWidgets.widgets
import qs.modules.lyrics

ExprDesktopWidget {
    id: card
    wType: "player"
    baseW: 400
    baseH: 380

    face: Component {
        HwCard {
            id: pc
            clip: true
            function fmt(s) {
                const t = Math.max(0, Math.round(s));
                return Math.floor(t / 60) + ":" + String(t % 60).padStart(2, "0");
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 58
                    spacing: 12

                    ShapeArt {
                        Layout.preferredWidth: 56
                        Layout.preferredHeight: 56
                        shape: HwConfig.player.artShape
                        artUrl: HwState.mediaArtUrl
                        spinning: false
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 1
                        Text {
                            Layout.fillWidth: true
                            text: HwState.mediaTitle !== "" ? HwState.mediaTitle : HwState.tr("no_media_playing")
                            elide: Text.ElideRight
                            font.family: HwState.fontPrimary
                            font.pixelSize: Math.round(15 * HwState.fontScale)
                            font.weight: Font.Bold
                            color: HwPal.colorOnSurface
                        }
                        Text {
                            Layout.fillWidth: true
                            visible: HwState.mediaArtist !== ""
                            text: HwState.mediaArtist
                            elide: Text.ElideRight
                            font.family: HwState.fontSecondary
                            font.pixelSize: Math.round(12 * HwState.fontScale)
                            color: HwPal.muted
                        }
                    }

                    Rectangle {
                        Layout.alignment: Qt.AlignVCenter
                        implicitHeight: 44
                        implicitWidth: pillRow.implicitWidth + 12
                        radius: height / 2
                        color: HwM3.alpha(HwM3.inkSurface, 0.10)
                        RowLayout {
                            id: pillRow
                            anchors.centerIn: parent
                            spacing: 6
                            HwIconButton {
                                implicitWidth: 32; implicitHeight: 32
                                icon: "lyrics"; iconSize: 18
                                fill: HwConfig.player.showLyrics ? HwM3.primary : HwM3.alpha(HwM3.inkSurface, 0.10)
                                ink: HwConfig.player.showLyrics ? HwM3.c.m3onPrimary : HwM3.inkSurface
                                onClicked: HwConfig.player.showLyrics = !HwConfig.player.showLyrics
                            }
                            HwIconButton {
                                implicitWidth: 30; implicitHeight: 30
                                icon: "skip_previous"; iconSize: 18
                                fill: "transparent"; ink: HwM3.inkSurface
                                onClicked: MprisController.previous()
                            }
                            HwIconButton {
                                implicitWidth: 38; implicitHeight: 38
                                icon: HwState.mediaStatus === "Playing" ? "pause" : "play_arrow"
                                iconSize: 22
                                fill: HwM3.alpha(HwM3.inkSurface, 0.22)
                                ink: HwM3.inkSurface
                                onClicked: MprisController.togglePlaying()
                            }
                            HwIconButton {
                                implicitWidth: 30; implicitHeight: 30
                                icon: "skip_next"; iconSize: 18
                                fill: "transparent"; ink: HwM3.inkSurface
                                onClicked: MprisController.next()
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 18
                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 2
                            radius: 1
                            color: HwM3.alpha(HwM3.inkSurface, 0.22)
                        }
                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * HwState.mediaProgress
                            height: 2
                            radius: 1
                            color: HwM3.alpha(HwM3.inkSurface, 0.7)
                            Behavior on width { NumberAnimation { duration: 600; easing.type: Easing.Linear } }
                        }
                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            x: Math.max(0, Math.min(parent.width - width, parent.width * HwState.mediaProgress - width / 2))
                            width: seek.pressed ? 12 : 8
                            height: width
                            radius: width / 2
                            color: HwM3.inkSurface
                            Behavior on width { NumberAnimation { duration: 120 } }
                        }
                        MouseArea {
                            id: seek
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onPressed: mouse => HwState.seekAbsolute(Math.max(0, Math.min(1, mouse.x / width)) * HwState.mediaLength)
                            onPositionChanged: mouse => { if (pressed) HwState.seekAbsolute(Math.max(0, Math.min(1, mouse.x / width)) * HwState.mediaLength); }
                        }
                    }
                    Text {
                        text: pc.fmt(HwState.mediaLength)
                        font.family: HwState.fontSecondary
                        font.pixelSize: Math.round(10 * HwState.fontScale)
                        color: HwPal.muted
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    visible: HwConfig.player.showLyrics
                    color: HwM3.alpha(HwM3.inkSurface, 0.10)
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: HwConfig.player.showLyrics
                    PlayerLyrics {
                        anchors.fill: parent
                        styleName: HwConfig.player.theme
                        textAlignment: HwConfig.player.align === "center" ? Text.AlignHCenter : HwConfig.player.align === "right" ? Text.AlignRight : Text.AlignLeft
                    }
                }
                Item { Layout.fillHeight: true; visible: !HwConfig.player.showLyrics }
            }
        }
    }
}
