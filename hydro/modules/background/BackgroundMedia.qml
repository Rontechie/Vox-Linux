import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    property real canvasWidth: 0
    property real canvasHeight: 0

    readonly property var cfg: Config.options.background.widgets.media
    readonly property var player: MprisController.activePlayer
    readonly property bool hasMedia: player !== null && (player.trackTitle ?? "") !== ""
    readonly property bool playing: player?.playbackState === MprisPlaybackState.Playing
    readonly property string title: player?.trackTitle ?? ""
    readonly property string artist: player?.trackArtist ?? ""
    readonly property string album: player?.trackAlbum ?? ""
    readonly property string artUrl: MprisController.activeTrack?.artUrl ?? ""

    readonly property real coverSize: cfg.size
    readonly property real pad: coverSize * 0.30
    readonly property real lyricSize: coverSize * 0.62
    readonly property real infoSize: coverSize * 0.56

    visible: cfg.enable && hasMedia && (!cfg.showOnlyWhenLocked || GlobalStates.screenLocked)
    width: coverSize + pad * 2
    height: coverSize + pad * 2
    x: cfg.placementStrategy === "center" ? (canvasWidth - width) / 2 : cfg.x
    y: cfg.placementStrategy === "center" ? canvasHeight * 0.55 : cfg.y

    Binding {
        target: LyricsService
        property: "active"
        value: root.visible && root.cfg.lyrics
    }

    property string shownLine: ""
    readonly property string wantedLine: {
        if (LyricsService.hasLyrics) return LyricsService.currentLine !== "" ? LyricsService.currentLine : "♪";
        if (LyricsService.status === "loading") return "♪";
        return root.title;
    }
    onWantedLineChanged: lineSwap.restart()
    Component.onCompleted: shownLine = wantedLine

    MaterialShape {
        id: cookie
        x: root.pad
        y: root.pad
        shape: MaterialShape.Shape.Cookie12Sided
        implicitSize: root.coverSize
        color: Appearance.colors.colSecondaryContainer
        RotationAnimator on rotation {
            from: 0
            to: 360
            duration: 120000
            loops: Animation.Infinite
            running: root.visible && root.cfg.rotateCover && root.playing
        }
    }

    ClippingRectangle {
        id: coverClip
        width: root.coverSize * 0.74
        height: width
        x: cookie.x + (root.coverSize - width) / 2
        y: cookie.y + (root.coverSize - height) / 2
        radius: width / 2
        color: Appearance.colors.colLayer1

        StyledImage {
            anchors.fill: parent
            source: root.artUrl
            fillMode: Image.PreserveAspectCrop
            sourceSize.width: coverClip.width * 2
            sourceSize.height: coverClip.height * 2
        }
        MaterialSymbol {
            anchors.centerIn: parent
            visible: root.artUrl === ""
            text: "music_note"
            iconSize: coverClip.width * 0.4
            color: Appearance.colors.colSubtext
        }

        SequentialAnimation {
            id: coverPop
            NumberAnimation { target: coverClip; property: "scale"; to: 0.92; duration: 90 }
            NumberAnimation {
                target: coverClip; property: "scale"; to: 1
                duration: Appearance.animationCurves.expressiveDefaultSpatialDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animationCurves.expressiveDefaultSpatial
            }
        }
    }
    onArtUrlChanged: coverPop.restart()

    Item {
        id: lyricBadge
        visible: root.cfg.lyrics
        width: root.lyricSize
        height: width
        x: root.pad - width * 0.46
        y: root.pad - height * 0.42

        MaterialShape {
            anchors.centerIn: parent
            shape: MaterialShape.Shape.Pentagon
            implicitSize: lyricBadge.width
            color: Appearance.colors.colTertiaryContainer
        }
        StyledText {
            id: lyricText
            anchors.centerIn: parent
            width: parent.width * 0.62
            height: parent.height * 0.50
            text: root.shownLine
            wrapMode: Text.WordWrap
            maximumLineCount: 4
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.Fit
            minimumPixelSize: 8
            font.pixelSize: 15
            font.weight: Font.Medium
            color: Appearance.colors.colOnTertiaryContainer
            transformOrigin: Item.Center
        }
        SequentialAnimation {
            id: lineSwap
            NumberAnimation { target: lyricText; property: "opacity"; to: 0; duration: 110 }
            ScriptAction { script: { root.shownLine = root.wantedLine; lyricText.scale = 0.88; } }
            ParallelAnimation {
                NumberAnimation { target: lyricText; property: "opacity"; to: 1; duration: Appearance.animationCurves.expressiveEffectsDuration }
                NumberAnimation {
                    target: lyricText; property: "scale"; to: 1
                    duration: Appearance.animationCurves.expressiveDefaultSpatialDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.animationCurves.expressiveDefaultSpatial
                }
            }
        }
    }

    Item {
        id: infoBadge
        width: root.infoSize
        height: width
        x: root.pad + root.coverSize - width * 0.54
        y: root.pad + root.coverSize - height * 0.54

        MaterialShape {
            anchors.centerIn: parent
            shape: MaterialShape.Shape.Circle
            implicitSize: infoBadge.width
            color: Appearance.colors.colPrimaryContainer
        }
        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width * 0.74
            spacing: 2
            StyledText {
                Layout.fillWidth: true
                text: root.artist
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.WordWrap
                fontSizeMode: Text.Fit
                minimumPixelSize: 9
                font.pixelSize: 14
                font.weight: Font.Medium
                color: Appearance.colors.colOnPrimaryContainer
            }
            StyledText {
                Layout.fillWidth: true
                visible: root.album !== ""
                text: root.album
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.WordWrap
                fontSizeMode: Text.Fit
                minimumPixelSize: 8
                font.pixelSize: 11
                color: SettingsTheme.withAlpha(Appearance.colors.colOnPrimaryContainer, 0.7)
            }
        }
    }
}
