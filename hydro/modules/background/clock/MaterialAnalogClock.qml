import qs
import qs.modules.common
import QtQuick
import QtQuick.Shapes
import Quickshell

Item {
    id: root
    readonly property var ck: Config.options.background.widgets.clock.cookie
    property real size: ck.size
    implicitWidth: size
    implicitHeight: size
    readonly property real s: size

    readonly property bool showSeconds: ck.secondHandStyle !== "hide" || GlobalStates.screenLocked

    readonly property color dialColor: Appearance.m3colors.m3primaryContainer
    readonly property color hourColor: Appearance.m3colors.m3secondary
    readonly property color minuteColor: Appearance.m3colors.m3primary
    readonly property color indicatorColor: Appearance.m3colors.m3tertiary

    SystemClock {
        id: clock
        precision: root.showSeconds ? SystemClock.Seconds : SystemClock.Minutes
    }
    readonly property int seconds: clock.date.getSeconds()
    readonly property real minutes: clock.date.getMinutes() + seconds / 60
    readonly property real hours: (clock.date.getHours() % 12) + minutes / 60

    property real headAngle: clock.date.getSeconds() * 6
    property real tailAngle: headAngle
    property int lastSecond: clock.date.getSeconds()

    function morphSecond(sec) {
        if (!showSeconds) return;
        if (morphAnim.running) {
            morphAnim.stop();
            headAngle = Math.round(((headAnim.to % 360) + 360) % 360);
            tailAngle = headAngle;
        }
        const target = sec * 6;
        const cur = Math.round(((tailAngle % 360) + 360) % 360);
        const diff = (target - cur + 360) % 360;
        if (diff === 0) return;
        if (diff > 12) { // a jump (wake from sleep, first tick): no animation
            headAngle = target;
            tailAngle = target;
            return;
        }
        headAnim.from = tailAngle;
        headAnim.to = tailAngle + diff;
        tailAnim.from = tailAngle;
        tailAnim.to = tailAngle + diff;
        morphAnim.restart();
    }
    onSecondsChanged: {
        if (seconds !== lastSecond) {
            lastSecond = seconds;
            morphSecond(seconds);
        }
    }

    ParallelAnimation {
        id: morphAnim
        NumberAnimation { id: headAnim; target: root; property: "headAngle"; duration: 250; easing.type: Easing.OutCubic }
        SequentialAnimation {
            PauseAnimation { duration: 100 }
            NumberAnimation { id: tailAnim; target: root; property: "tailAngle"; duration: 250; easing.type: Easing.OutCubic }
        }
        onFinished: {
            root.headAngle = Math.round(((root.headAngle % 360) + 360) % 360);
            root.tailAngle = root.headAngle;
        }
    }

    Canvas {
        id: dial
        anchors.fill: parent
        antialiasing: true
        property color fillColor: root.dialColor
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onFillColorChanged: requestPaint()
        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            const cx = width / 2, cy = height / 2;
            const size = Math.min(width, height);
            const lobes = 12, rMid = size * 0.46, rAmp = size * 0.012, steps = 240;
            ctx.beginPath();
            for (let i = 0; i <= steps; i++) {
                const a = (i / steps) * Math.PI * 2;
                const r = rMid + rAmp * Math.cos(lobes * a);
                const x = cx + r * Math.sin(a), y = cy - r * Math.cos(a);
                if (i === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
            }
            ctx.closePath();
            ctx.fillStyle = fillColor;
            ctx.fill();
        }
    }

    Shape {
        visible: root.showSeconds
        anchors.fill: parent
        z: 3
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            strokeColor: root.indicatorColor
            strokeWidth: root.s * 0.034
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            PathAngleArc {
                centerX: root.s / 2
                centerY: root.s / 2
                radiusX: root.s * 0.40
                radiusY: root.s * 0.40
                startAngle: root.tailAngle - 90
                sweepAngle: Math.max(0.5, root.headAngle - root.tailAngle)
            }
        }
    }

    Item {
        anchors.centerIn: parent
        z: 1
        rotation: root.hours * 30
        Behavior on rotation { RotationAnimation { duration: 400; direction: RotationAnimation.Clockwise; easing.type: Easing.OutCubic } }
        Rectangle {
            width: root.s * 0.076
            height: root.s * 0.24
            radius: width / 2
            color: root.hourColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            anchors.bottomMargin: -width / 2
            antialiasing: true
        }
    }
    Item {
        anchors.centerIn: parent
        z: 2
        rotation: root.minutes * 6
        Behavior on rotation { RotationAnimation { duration: 400; direction: RotationAnimation.Clockwise; easing.type: Easing.OutCubic } }
        Rectangle {
            width: root.s * 0.082
            height: root.s * 0.36
            radius: width / 2
            color: root.minuteColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            anchors.bottomMargin: -width / 2
            antialiasing: true
        }
    }
}
