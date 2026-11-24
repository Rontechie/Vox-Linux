import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

Item {
    id: root
    readonly property MprisPlayer player: MprisController.activePlayer
    readonly property real length: player?.length ?? 0
    readonly property real position: player?.position ?? 0

    Timer {
        running: root.visible && (root.player?.playbackState == MprisPlaybackState.Playing)
        interval: 1000
        repeat: true
        onTriggered: root.player.positionChanged()
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width - 32
        spacing: 14
        visible: root.player !== null

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 260
            implicitHeight: 260
            radius: Appearance.rounding.large
            color: Appearance.colors.colLayer1
            clip: true
            StyledImage {
                anchors.fill: parent
                source: root.player?.trackArtUrl ?? ""
                sourceSize: Qt.size(520, 520)
                fillMode: Image.PreserveAspectCrop
                visible: source != ""
            }
            MaterialSymbol {
                anchors.centerIn: parent
                visible: !(root.player?.trackArtUrl > "")
                text: "music_note"
                iconSize: 80
                color: Appearance.colors.colOnLayer1
            }
        }

        StyledText {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            font.pixelSize: Appearance.font.pixelSize.larger
            color: Appearance.colors.colOnLayer0
            text: root.player?.trackTitle || Translation.tr("No media")
        }
        StyledText {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            color: Appearance.colors.colSubtext
            text: root.player?.trackArtist ?? ""
        }

        Rectangle { // progress
            Layout.fillWidth: true
            implicitHeight: 6
            radius: 3
            color: Appearance.colors.colLayer1
            Rectangle {
                width: root.length > 0 ? parent.width * Math.min(1, root.position / root.length) : 0
                height: parent.height
                radius: 3
                color: Appearance.colors.colPrimary
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10
            Repeater {
                model: [
                    { icon: "skip_previous", act: 0 },
                    { icon: "play_arrow", act: 1 },
                    { icon: "skip_next", act: 2 }
                ]
                delegate: RippleButton {
                    required property var modelData
                    implicitWidth: modelData.act === 1 ? 64 : 48
                    implicitHeight: 48
                    buttonRadius: Appearance.rounding.full
                    toggled: modelData.act === 1
                    onClicked: {
                        if (modelData.act === 0) MprisController.previous();
                        else if (modelData.act === 1) MprisController.togglePlaying();
                        else MprisController.next();
                    }
                    MaterialSymbol {
                        anchors.centerIn: parent
                        fill: 1
                        iconSize: 28
                        text: (modelData.act === 1 && MprisController.isPlaying) ? "pause" : modelData.icon
                        color: modelData.act === 1 ? Appearance.m3colors.m3onPrimary : Appearance.colors.colOnLayer1
                    }
                }
            }
        }
    }

    StyledText {
        anchors.centerIn: parent
        visible: root.player === null
        color: Appearance.colors.colSubtext
        text: Translation.tr("Nothing is playing")
    }
}
