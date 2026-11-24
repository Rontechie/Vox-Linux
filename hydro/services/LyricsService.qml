pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import qs.services

Singleton {
    id: root

    property bool active: false
    readonly property var player: MprisController.activePlayer
    property var lines: []                  // [{ t: seconds, text: "..." }], sorted by t
    property int index: -1                  // line being sung now
    property string status: "idle"          // idle | loading | synced | none | error
    readonly property bool hasLyrics: status === "synced" && lines.length > 0
    readonly property string currentLine: (index >= 0 && index < lines.length) ? lines[index].text : ""
    readonly property string nextLine: (index + 1 < lines.length) ? lines[index + 1].text : ""

    property string key: ""
    property var cache: ({})                // key -> lines
    property var lengths: ({})              // key -> track length when requested
    property var queued: null
    readonly property bool playing: player?.playbackState === MprisPlaybackState.Playing

    function currentKey() {
        const t = (player?.trackTitle ?? "").replace(/\n/g, " ").trim();
        const a = (player?.trackArtist ?? "").replace(/\n/g, " ").trim();
        if (!t) return "";
        return a + "\u241f" + t;           // visible separator that cannot appear in a path
    }

    function refresh() {
        if (!active) return;
        const k = currentKey();
        if (k === key && status !== "idle") return;
        key = k;
        lines = [];
        index = -1;
        if (!k) { status = "idle"; return; }
        if (cache[k] !== undefined) {
            lines = cache[k];
            status = lines.length > 0 ? "synced" : "none";
            updateIndex();
            return;
        }
        status = "loading";
        const parts = k.split("\u241f");
        request(k, parts[1], parts[0], player?.length ?? 0);
    }

    function request(k, title, artist, length) {
        queued = { key: k, title: title, artist: artist, length: length };
        if (!fetcher.running) startQueued();
    }

    function startQueued() {
        if (!queued) return;
        const q = queued;
        queued = null;
        lengths[q.key] = q.length;
        fetcher.command = ["sh", "-c",
            'printf "%s\\n" "$1"; exec curl -sS --max-time 8 -A "hydro-shell" -G ' +
            '--data-urlencode "track_name=$2" --data-urlencode "artist_name=$3" https://lrclib.net/api/search',
            "sh", q.key, q.title, q.artist];
        fetcher.running = true;
    }

    function parseLrc(text) {
        const out = [];
        for (const raw of text.split("\n")) {
            const m = raw.match(/^((?:\[\d+:\d+(?:[.:]\d+)?\])+)\s*(.*)$/);
            if (!m) continue;
            const body = m[2].trim();
            const re = /\[(\d+):(\d+)(?:[.:](\d+))?\]/g;
            let t;
            while ((t = re.exec(m[1])) !== null) {
                const frac = t[3] ? parseInt(t[3]) / Math.pow(10, t[3].length) : 0;
                out.push({ t: parseInt(t[1]) * 60 + parseInt(t[2]) + frac, text: body });
            }
        }
        out.sort((a, b) => a.t - b.t);
        return out;
    }

    function pick(results, length) {
        let best = null;
        let bestDiff = 1e9;
        for (const r of results) {
            if (!r.syncedLyrics) continue;
            const known = length > 0 && r.duration;
            const diff = known ? Math.abs(r.duration - length) : 0;
            if (known && diff > 6) continue;
            if (diff < bestDiff) { best = r; bestDiff = diff; }
        }
        return best;
    }

    function handle(output) {
        const nl = output.indexOf("\n");
        if (nl < 0) return;
        const k = output.substring(0, nl);
        const body = output.substring(nl + 1);
        let result = [];
        let ok = true;
        try {
            const arr = JSON.parse(body);
            const best = Array.isArray(arr) ? pick(arr, lengths[k] ?? 0) : null;
            if (best) result = parseLrc(best.syncedLyrics);
        } catch (e) {
            ok = false;
        }
        if (ok) {
            const c = cache;
            c[k] = result;
            cache = c;
        }
        if (k !== key) return;             // the track changed while we waited
        lines = result;
        status = !ok ? "error" : (result.length > 0 ? "synced" : "none");
        updateIndex();
    }

    function updateIndex() {
        if (!hasLyrics || !player) { index = -1; return; }
        const pos = player.position;
        let lo = 0, hi = lines.length - 1, found = -1;
        while (lo <= hi) {
            const mid = (lo + hi) >> 1;
            if (lines[mid].t <= pos) { found = mid; lo = mid + 1; } else hi = mid - 1;
        }
        if (found !== index) index = found;
    }

    onActiveChanged: refresh()
    onPlayerChanged: { key = ""; refresh(); }

    Connections {
        target: MprisController
        function onTrackChanged() { root.refresh(); }
    }
    Connections {
        target: root.player
        function onPositionChanged() { root.updateIndex(); }
    }
    Timer {
        interval: 250
        repeat: true
        running: root.active && root.hasLyrics && root.playing
        onTriggered: root.player.positionChanged()
    }

    Process {
        id: fetcher
        stdout: StdioCollector {
            onStreamFinished: root.handle(text)
        }
        onExited: root.startQueued()
    }
}
