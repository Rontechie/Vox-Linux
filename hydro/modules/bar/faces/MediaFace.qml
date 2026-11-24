import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Widgets
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    property bool isPreview: false
    readonly property var cfg: Config.options.bar.mediaFace
    readonly property real ws: Config.options.bar.sizes.widgetScale
    readonly property real fs: Config.options.bar.sizes.fontScale
    function sc(v) { return Math.round(v * ws); }

    readonly property var player: MprisController.activePlayer
    readonly property bool isMediaActive: isPreview || (player !== null && player.playbackState !== MprisPlaybackState.Stopped && (player.trackTitle ?? "") !== "")
    readonly property bool isPlaying: isPreview || (isMediaActive && player?.playbackState === MprisPlaybackState.Playing)
    readonly property string artUrl: isPreview ? "" : (MprisController.activeTrack?.artUrl ?? "")
    readonly property bool hasArt: isMediaActive && artUrl !== ""

    readonly property bool shown: !(cfg.hideWhenIdle && !isPreview && !isMediaActive)
    readonly property bool showIcon: cfg.showIcon
    readonly property bool showControls: cfg.showControls
    readonly property real colWidth: sc(cfg.width)

    readonly property real unit: sc(28)      // cover size
    readonly property real btn: sc(30)       // button size
    readonly property real radius: sc(10)

    Component.onCompleted: console.log("[MediaFace] loaded")

    implicitWidth: shown ? layout.implicitWidth + sc(8) * 2 : 0
    implicitHeight: sc(30)

    function formatTime(sec) {
        sec = Math.floor(sec || 0);
        const m = Math.floor(sec / 60), s = sec % 60;
        return (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s;
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.visible && root.isMediaActive && root.isPlaying && !root.isPreview && root.cfg.infoMode !== "author"
        onTriggered: root.player?.positionChanged()
    }

    Row {
        id: layout
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: root.sc(8)

        MouseArea {
            id: infoMouse
            width: info.implicitWidth
            height: root.implicitHeight
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: GlobalStates.mediaControlsOpen = !GlobalStates.mediaControlsOpen

            Row {
                id: info
                anchors.verticalCenter: parent.verticalCenter
                spacing: root.sc(10)
                transformOrigin: Item.Left
                scale: infoMouse.containsMouse ? 1.01 : 1.0
                Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutExpo } }

                ClippingRectangle {
                    visible: root.showIcon
                    anchors.verticalCenter: parent.verticalCenter
                    width: root.unit
                    height: root.unit
                    radius: root.radius
                    color: FacePal.surface1
                    StyledImage {
                        anchors.fill: parent
                        visible: root.hasArt
                        source: root.artUrl
                        fillMode: Image.PreserveAspectCrop
                        sourceSize.width: root.unit * 2
                        sourceSize.height: root.unit * 2
                    }
                    MaterialSymbol {
                        anchors.centerIn: parent
                        visible: !root.hasArt
                        text: "music_note"
                        iconSize: root.unit * 0.55
                        color: FacePal.subtext0
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: -2
                    width: root.colWidth

                    MarqueeText {
                        width: parent.width
                        text: root.isPreview ? Translation.tr("Song title")
                            : (root.isMediaActive ? (root.player?.trackTitle ?? "") : Translation.tr("Nothing playing"))
                        color: FacePal.text
                        fontFamily: FacePal.fontFamily
                        fontWeight: Font.Black
                        fontPixelSize: Appearance.font.pixelSize.small * root.fs
                        marqueeSpacing: root.sc(40)
                        speed: 30
                        active: root.visible && root.isPlaying
                    }
                    Text {
                        visible: root.isMediaActive
                        width: parent.width
                        elide: Text.ElideRight
                        font.family: FacePal.fontFamily
                        font.weight: Font.Black
                        font.pixelSize: Appearance.font.pixelSize.smallest * root.fs
                        color: FacePal.subtext0
                        text: root.cfg.infoMode === "author"
                            ? (root.isPreview ? Translation.tr("Song author") : (root.player?.trackArtist ?? ""))
                            : (root.isPreview ? "01:24 / 03:42" : root.formatTime(root.player?.position) + " / " + root.formatTime(root.player?.length))
                    }
                }
            }
        }

        Row {
            visible: root.showControls
            anchors.verticalCenter: parent.verticalCenter
            spacing: root.sc(4)

            Repeater {
                model: [ { act: 0, icon: "skip_previous" }, { act: 1, icon: "play_arrow" }, { act: 2, icon: "skip_next" } ]
                delegate: Rectangle {
                    id: b
                    required property var modelData
                    readonly property bool usable: root.isPreview || (modelData.act === 0 ? MprisController.canGoPrevious
                                                : modelData.act === 1 ? MprisController.canTogglePlaying
                                                : MprisController.canGoNext)
                    width: root.btn
                    height: root.btn
                    radius: root.radius
                    color: !usable ? Qt.alpha(FacePal.surface0, 0.5) : (bm.containsMouse ? FacePal.surface1 : FacePal.surface0)
                    opacity: usable ? 1 : 0.5
                    scale: bm.pressed && usable ? 0.9 : 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutBack } }

                    MaterialSymbol {
                        anchors.centerIn: parent
                        fill: 1
                        text: b.modelData.act === 1 ? (root.isPlaying ? "pause" : "play_arrow") : b.modelData.icon
                        iconSize: root.btn * 0.62
                        color: b.modelData.act === 1 && bm.containsMouse ? FacePal.primary : (bm.containsMouse ? FacePal.text : FacePal.subtext0)
                    }
                    MouseArea {
                        id: bm
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: b.usable && !root.isPreview
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (b.modelData.act === 0) MprisController.previous();
                            else if (b.modelData.act === 1) MprisController.togglePlaying();
                            else MprisController.next();
                        }
                    }
                }
            }
        }
    }
}
