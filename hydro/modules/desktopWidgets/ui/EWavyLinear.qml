import QtQuick

Item {
    id: ew
    property real value: 0
    property bool animateValue: true
    property color active: "#D0BCFF"
    property color track: "#33FFFFFF"
    property bool wavy: true
    property bool showHandle: true
    property real handleH: 22
    property real thickness: 4
    property real amplitude: 3
    property real wavelength: 30
    property bool running: true
    property real phase: 0

    implicitHeight: 26
    readonly property real shown: Math.max(0, Math.min(1, value))
    Behavior on value { enabled: ew.animateValue; NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

    FrameAnimation {
        running: ew.running && ew.wavy && ew.visible
        onTriggered: ew.phase = (ew.phase + frameTime * 3.2) % (Math.PI * 2)
    }

    Canvas {
        id: cv
        anchors.fill: parent
        antialiasing: true
        property real v: ew.shown
        property real ph: ew.phase
        onVChanged: requestPaint()
        onPhChanged: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Component.onCompleted: requestPaint()
        onPaint: {
            const ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            const cy = height / 2, lw = ew.thickness, gap = 6 + (ew.showHandle ? 3 : 0);
            const hx = Math.max(lw / 2, Math.min(width - lw / 2, width * v));
            ctx.lineCap = "round";
            ctx.lineWidth = lw;
            if (hx + gap < width - lw / 2) {
                ctx.beginPath();
                ctx.moveTo(hx + gap, cy);
                ctx.lineTo(width - lw / 2, cy);
                ctx.strokeStyle = ew.track.toString();
                ctx.stroke();
            }
            const end = hx - gap;
            if (end > lw / 2) {
                ctx.beginPath();
                const k = 2 * Math.PI / Math.max(4, ew.wavelength);
                for (let x = lw / 2; x <= end; x += 1) {
                    const taper = Math.min(1, (x - lw / 2) / 12, (end - x) / 12 + 0.0);
                    const y = cy + (ew.wavy ? Math.sin(x * k + ew.phase) * ew.amplitude * Math.max(0, taper) : 0);
                    if (x === lw / 2) ctx.moveTo(x, y); else ctx.lineTo(x, y);
                }
                ctx.strokeStyle = ew.active.toString();
                ctx.stroke();
            }
            if (ew.showHandle) {
                const hw = 4, hh = ew.handleH;
                ctx.beginPath();
                ctx.moveTo(hx, cy - hh / 2);
                ctx.lineTo(hx, cy + hh / 2);
                ctx.lineWidth = hw;
                ctx.strokeStyle = ew.active.toString();
                ctx.stroke();
            }
        }
    }
}
