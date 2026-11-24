import QtQuick
import qs.modules.desktopWidgets.ui
import qs.modules.desktopWidgets.widgets

ExprDesktopWidget {
    id: card
    wType: "stopwatch"
    baseW: 300
    baseH: 280

    property bool running: false
    property real elapsedMs: 0
    property real baseMs: 0
    property real startedAt: 0
    property var laps: []

    Timer {
        interval: 30
        repeat: true
        running: card.running
        onTriggered: card.elapsedMs = card.baseMs + (Date.now() - card.startedAt)
    }
    function toggle() {
        if (running) {
            elapsedMs = baseMs + (Date.now() - startedAt);
            baseMs = elapsedMs;
            running = false;
        } else {
            startedAt = Date.now();
            running = true;
        }
    }
    function lap() {
        const total = Math.round(elapsedMs);
        const prev = laps.length > 0 ? laps[laps.length - 1].totalMs : 0;
        laps = laps.concat([{ n: laps.length + 1, splitMs: total - prev, totalMs: total }]);
    }
    function reset() {
        running = false;
        elapsedMs = 0;
        baseMs = 0;
        laps = [];
    }

    face: Component {
        HwCard {
            StopwatchFace {
                anchors.fill: parent
                anchors.margins: 12
                colorPrimary: HwM3.primary
                colorPrimaryCont: HwM3.primaryContainer
                colorOnPrimaryCont: HwM3.inkPrimaryContainer
                colorOnSurfVar: HwPal.colorOnSurface
                colorSurface: HwM3.secondaryContainer
                running: card.running
                elapsedMs: card.elapsedMs
                laps: card.laps
                onStartPauseClicked: card.toggle()
                onLapClicked: card.lap()
                onResetClicked: card.reset()
            }
        }
    }
}
