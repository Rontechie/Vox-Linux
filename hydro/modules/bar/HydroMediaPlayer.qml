import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Widgets
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    readonly property real ws: Config.options.bar.sizes.widgetScale
    readonly property real fs: Config.options.bar.sizes.fontScale

    readonly property var player: MprisController.activePlayer
    readonly property string title: player?.trackTitle ?? ""
    readonly property bool hasMedia: player !== null && title !== ""
    readonly property bool playing: player?.playbackState == MprisPlaybackState.Playing
    readonly property string artUrl: MprisController.activeTrack?.artUrl ?? ""
    readonly property real position: player?.position ?? 0
    readonly property real length: player?.length ?? 0
    readonly property real unit: 28 * ws                 // size of the cover and of each button

    implicitWidth: pill.visible ? pill.implicitWidth : 0
    implicitHeight: pill.implicitHeight

    function fmt(seconds) {
        const s = Math.max(0, Math.floor(seconds));
        const h = Math.floor(s / 3600);
        const m = Math.floor((s % 3600) / 60);
        const sec = s % 60;
        const pad = n => (n < 10 ? "0" : "") + n;
        return (h > 0 ? h + ":" : "") + pad(m) + ":" + pad(sec);
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.visible && root.hasMedia && root.playing
        onTriggered: root.player.positionChanged()
    }

    HydroPill {
        id: pill
        clickable: false
        hPadding: 8 * root.ws
        spacing: 10 * root.ws
        visible: root.hasMedia

        ClippingRectangle {
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: root.unit
            implicitHeight: root.unit
            radius: 9 * root.ws
            color: Appearance.colors.colLayer1

            StyledImage {
                anchors.fill: parent
                visible: root.artUrl !== ""
                source: root.artUrl
                fillMode: Image.PreserveAspectCrop
                sourceSize.width: root.unit * 2
                sourceSize.height: root.unit * 2
            }
            MaterialSymbol {
                anchors.centerIn: parent
                visible: root.artUrl === ""
                text: "music_note"
                iconSize: root.unit * 0.55
                color: Appearance.colors.colSubtext
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 0

            StyledText {
                Layout.maximumWidth: 170 * root.ws
                elide: Text.ElideRight
                animateChange: true
                text: root.title
                font.pixelSize: Appearance.font.pixelSize.small * root.fs
                font.weight: Font.Bold
                color: Appearance.colors.colOnLayer0
            }
            StyledText {
                text: root.length > 0 ? root.fmt(root.position) + " / " + root.fmt(root.length) : root.fmt(root.position)
                font.family: Appearance.font.family.monospace
                font.pixelSize: Appearance.font.pixelSize.smallest * root.fs
                color: Appearance.colors.colSubtext
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 6 * root.ws

            Repeater {
                model: [
                    { act: 0, icon: "skip_previous" },
                    { act: 1, icon: "pause" },
                    { act: 2, icon: "skip_next" }
                ]
                delegate: Rectangle {
                    id: btn
                    required property var modelData
                    readonly property bool usable: modelData.act === 0 ? MprisController.canGoPrevious
                                                 : modelData.act === 1 ? MprisController.canTogglePlaying
                                                 : MprisController.canGoNext
                    implicitWidth: root.unit
                    implicitHeight: root.unit
                    radius: 9 * root.ws
                    color: !usable ? "#0dffffff" : (btnMouse.containsMouse ? "#33ffffff" : "#1affffff")
                    opacity: usable ? 1 : 0.45
                    scale: (btnMouse.pressed && usable) ? 0.9 : 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on scale { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }

                    MaterialSymbol {
                        anchors.centerIn: parent
                        fill: 1
                        text: btn.modelData.act === 1 ? (root.playing ? "pause" : "play_arrow") : btn.modelData.icon
                        iconSize: root.unit * 0.62
                        color: Appearance.colors.colOnLayer0
                    }
                    MouseArea {
                        id: btnMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: btn.usable
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (btn.modelData.act === 0) MprisController.previous();
                            else if (btn.modelData.act === 1) MprisController.togglePlaying();
                            else MprisController.next();
                        }
                    }
                }
            }
        }
    }
}
