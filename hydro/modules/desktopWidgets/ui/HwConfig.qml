pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common
import qs.modules.common.functions

Singleton {
    id: root

    readonly property string filePath: FileUtils.trimFileProtocol(`${Directories.state}/user/desktop-widgets.json`)

    property bool editMode: false
    property string selected: ""
    property bool galleryOpen: true
    onEditModeChanged: {
        if (editMode) galleryOpen = true;
        else selected = "";
    }

    function isEnabled(name) {
        if (name === "cava") return cava.enable;
        const w = widget(name);
        return w ? w.enable === true : false;
    }
    function setEnabled(name, on) {
        if (name === "cava") { cava.enable = on; return; }
        const w = widget(name);
        if (w) w.enable = on;
    }

    readonly property alias general: adapter.general
    readonly property alias media: adapter.media
    readonly property alias lyrics: adapter.lyrics
    readonly property alias player: adapter.player
    readonly property alias weather: adapter.weather
    readonly property alias system: adapter.system
    readonly property alias gauge: adapter.gauge
    readonly property alias stopwatch: adapter.stopwatch
    readonly property alias cava: adapter.cava

    readonly property var widgetNames: ["media", "lyrics", "player", "weather", "system", "gauge", "stopwatch"]

    function widget(name) {
        switch (name) {
        case "media": return adapter.media;
        case "lyrics": return adapter.lyrics;
        case "player": return adapter.player;
        case "weather": return adapter.weather;
        case "system": return adapter.system;
        case "gauge": return adapter.gauge;
        case "stopwatch": return adapter.stopwatch;
        }
        return null;
    }
    function setPosition(name, x, y) {
        const w = widget(name);
        if (!w) return;
        w.x = x;
        w.y = y;
    }
    readonly property bool anyLive: media.enable || lyrics.enable || player.enable || weather.enable || system.enable || gauge.enable || stopwatch.enable || cava.enable

    FileView {
        id: file
        path: root.filePath
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeTimer.restart()
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound)
                writeAdapter();
        }

        JsonAdapter {
            id: adapter

            property JsonObject general: JsonObject {
                property real fontScale: 1.0
                property bool snapToGrid: true
                property real gridSize: 20
                property real edgeMargin: 60
                property string clockAnchor: "custom"
            }
            property JsonObject media: JsonObject {
                property bool enable: false
                property real x: 80
                property real y: 80
                property real scale: 1.0
                property string anchor: "custom"
                property string artStyle: "shape" // "shape" | "gear"
                property string shape: "Cookie9Sided"
                property bool showLyric: true
            }
            property JsonObject lyrics: JsonObject {
                property bool enable: false
                property real x: 80
                property real y: 300
                property real scale: 1.0
                property string anchor: "custom"
                property string align: "left" // left | center | right
                property string theme: "classic" // classic = the simple scroller, or a lyric theme: default reel cinematic neon editorial nocturne neonScript kinetic motion
            }
            property JsonObject player: JsonObject {
                property bool enable: false
                property real x: 80
                property real y: 80
                property real scale: 1.0
                property string anchor: "custom"
                property string theme: "neonScript" // lyric look: default cinematic neon editorial nocturne neonScript kinetic motion
                property string align: "center"     // left | center | right
                property string artShape: "Square"  // Square | Cookie9Sided | Circle | SoftBurst | Flower | Clover4Leaf | Pentagon | Heart
                property bool showLyrics: true
            }
            property JsonObject weather: JsonObject {
                property bool enable: false
                property real x: 500
                property real y: 80
                property real scale: 1.0
                property string anchor: "custom"
                property bool shapedCards: true
                property bool waveEffect: true
            }
            property JsonObject system: JsonObject {
                property bool enable: false
                property real x: 500
                property real y: 440
                property real scale: 1.0
                property string anchor: "custom"
            }
            property JsonObject gauge: JsonObject {
                property bool enable: false
                property real x: 860
                property real y: 80
                property real scale: 1.0
                property string anchor: "custom"
                property string metric: "ram" // ram | cpu
                property string shape: "squircle" // squircle | arch | pill | fan
                property bool waveEffect: true
            }
            property JsonObject stopwatch: JsonObject {
                property bool enable: false
                property real x: 860
                property real y: 300
                property real scale: 1.0
                property string anchor: "custom"
            }
            property JsonObject cava: JsonObject {
                property bool enable: false
                property string style: "bars" // bars | wave
                property string edge: "bottom" // bottom | top | left | right
                property real height: 160
                property int resolution: 48
            }
        }
    }

    Timer {
        id: writeTimer
        interval: 150
        onTriggered: file.writeAdapter()
    }
}
