pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs
import qs.modules.common
import qs.services

Singleton {
    id: root

    readonly property string fontPrimary: Appearance.font.family.expressive
    readonly property string fontSecondary: Appearance.font.family.main
    readonly property real fontScale: HwConfig.general.fontScale
    readonly property bool profileMorphing: false

    readonly property bool desktopEditMode: HwConfig.editMode
    readonly property bool lockScreenActive: GlobalStates.screenLocked
    readonly property bool wpFullscreenActive: false

    readonly property var player: MprisController.activePlayer
    readonly property string mediaTitle: player?.trackTitle ?? ""
    readonly property string mediaArtist: player?.trackArtist ?? ""
    readonly property string mediaArtUrl: player?.trackArtUrl ?? ""
    readonly property string mediaStatus: MprisController.isPlaying ? "Playing" : (player ? "Paused" : "Stopped")
    readonly property real mediaLength: player?.length ?? 0
    property real mediaPosition: 0
    readonly property real mediaProgress: mediaLength > 0 ? Math.max(0, Math.min(1, mediaPosition / mediaLength)) : 0

    readonly property var mediaLyrics: LyricsService.lines.map(l => ({ t: l.t, s: l.text }))
    readonly property bool mediaLyricsSynced: LyricsService.hasLyrics
    readonly property int mediaLyricIndex: LyricsService.index
    readonly property bool mediaLyricsLoading: LyricsService.status === "loading"
    readonly property string mediaLyricLine: LyricsService.currentLine

    readonly property var desktopCavaBars: HwCava.values
    readonly property string desktopCavaStyle: HwConfig.cava.style
    readonly property string desktopCavaEdge: HwConfig.cava.edge
    readonly property real desktopCavaHeight: HwConfig.cava.height
    readonly property int desktopCavaResolution: HwConfig.cava.resolution

    function seekAbsolute(seconds) {
        if (player && player.canSeek) player.position = seconds;
    }
    function tr(key) {
        const t = {
            "no_media_playing": "Nothing playing",
            "lyrics_none": "No lyrics found",
            "lyrics_searching": "Searching for lyrics…",
            "weather_loading": "Loading weather…"
        };
        return Translation.tr(t[key] ?? key);
    }
    function weatherText(desc) { return Translation.tr(desc); }

    Timer {
        interval: 1000
        repeat: true
        running: root.mediaStatus === "Playing" && (HwConfig.media.enable || HwConfig.lyrics.enable || HwConfig.player.enable)
        triggeredOnStart: true
        onTriggered: {
            if (root.player) {
                root.player.positionChanged();
                root.mediaPosition = root.player.position;
            }
        }
    }
    Connections {
        target: root.player
        function onTrackChanged() { root.mediaPosition = 0; }
    }

    Binding {
        target: LyricsService
        property: "active"
        value: true
        when: HwConfig.lyrics.enable || (HwConfig.media.enable && HwConfig.media.showLyric) || (HwConfig.player.enable && HwConfig.player.showLyrics)
    }
    Binding { target: HwCava; property: "wanted"; value: HwConfig.cava.enable }
    Binding { target: HwCava; property: "bars"; value: HwConfig.cava.resolution }
    Binding { target: HwWeather; property: "wanted"; value: HwConfig.weather.enable }
}
