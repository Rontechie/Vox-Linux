pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool wanted: false
    property int bars: 48
    property list<real> values: []
    readonly property bool available: !failed
    property bool failed: false

    readonly property string confPath: "/tmp/hydro-desktop-cava.conf"

    function conf() {
        return "[general]\nbars = " + root.bars + "\nframerate = 30\n"
            + "[output]\nmethod = raw\nraw_target = /dev/stdout\ndata_format = ascii\nascii_max_range = 1000\n"
            + "bar_delimiter = 59\nframe_delimiter = 10\n";
    }

    Process {
        id: proc
        running: root.wanted
        command: ["bash", "-c", "printf '%s' \"$0\" > " + root.confPath + " && exec cava -p " + root.confPath, root.conf()]
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const parts = data.split(";");
                const out = [];
                for (let i = 0; i < parts.length; i++) {
                    if (parts[i].length === 0) continue;
                    out.push(Math.min(1, Math.max(0, parseInt(parts[i]) / 1000)));
                }
                if (out.length > 1) {
                    root.failed = false;
                    root.values = out;
                }
            }
        }
        onExited: (code, status) => {
            if (code !== 0 && root.wanted) {
                root.failed = true;
                retry.restart();
            }
        }
    }
    Timer {
        id: retry
        interval: 10000
        onTriggered: if (root.wanted) { proc.running = false; proc.running = true; }
    }
    onBarsChanged: if (proc.running) { proc.running = false; restartSoon.restart(); }
    Timer { id: restartSoon; interval: 200; onTriggered: if (root.wanted) proc.running = true }
}
