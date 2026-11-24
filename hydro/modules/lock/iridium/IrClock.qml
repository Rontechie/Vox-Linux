import QtQuick
import qs.modules.common

Canvas {
    id: root
    property string style: "gear"
    property bool showHands: true
    property bool showNums: true
    property bool use24h: false
    property bool running: true
    property string fontFamily: Appearance.font.family.expressive
    property real fontScale: 1
    property color faceColor: Appearance.colors.colSecondaryContainer
    property color accent: Appearance.colors.colPrimary
    property color handColor: Appearance.colors.colOnSecondaryContainer
    property color numColor: Appearance.colors.colOnSecondaryContainer
    property color hourColor: Appearance.colors.colPrimary
    property color minuteColor: "white"

    readonly property bool analog: style === "gear" || style === "circle"
    property int ch: 0
    property int ch24: 0
    property int cm: 0
    property int cs: 0
    readonly property string hourText: {
        const h = use24h ? ch24 : (ch === 0 ? 12 : ch);
        return h < 10 ? "0" + h : "" + h;
    }
    readonly property string minText: cm < 10 ? "0" + cm : "" + cm

    function tick() {
        const d = new Date();
        ch24 = d.getHours(); ch = ch24 % 12; cm = d.getMinutes(); cs = d.getSeconds();
        if (analog) requestPaint();
    }
    Timer {
        interval: 1000; repeat: true; triggeredOnStart: true
        running: root.running
        onTriggered: root.tick()
    }

    onStyleChanged: requestPaint()
    onShowHandsChanged: requestPaint()
    onShowNumsChanged: requestPaint()
    onFaceColorChanged: requestPaint()
    onAccentChanged: requestPaint()
    onHandColorChanged: requestPaint()
    onNumColorChanged: requestPaint()
    onFontFamilyChanged: requestPaint()
    onFontScaleChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    function drawFace(ctx, cx, cy, R, circle) {
        ctx.beginPath();
        if (circle) {
            ctx.arc(cx, cy, R, 0, Math.PI * 2);
        } else {
            const teeth = 12, rBase = R * 0.86, amp = R * 0.14, steps = 720;
            for (let i = 0; i <= steps; i++) {
                const a = (i / steps) * Math.PI * 2;
                const c = Math.cos(teeth / 2 * a);
                const r = rBase + amp * c * c;
                const px = cx + Math.cos(a) * r, py = cy + Math.sin(a) * r;
                if (i === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py);
            }
        }
        ctx.closePath();
        ctx.fillStyle = faceColor.toString();
        ctx.fill();
    }
    function drawNumbers(ctx, cx, cy, R) {
        ctx.globalAlpha = showHands ? 0.35 : 1.0;
        ctx.fillStyle = numColor.toString();
        ctx.font = "bold " + Math.round(R * 0.48 * fontScale) + "px '" + fontFamily + "'";
        ctx.textAlign = "center";
        ctx.textBaseline = "middle";
        const numR = R * 0.66;
        const nums = [[12, -Math.PI / 2], [3, 0], [6, Math.PI / 2], [9, Math.PI]];
        for (let n = 0; n < nums.length; n++)
            ctx.fillText("" + nums[n][0], cx + Math.cos(nums[n][1]) * numR, cy + Math.sin(nums[n][1]) * numR + R * 0.03);
        ctx.globalAlpha = 1;
    }
    function drawHands(ctx, cx, cy, S, k) {
        const hourA = ((ch + cm / 60) / 12) * Math.PI * 2 - Math.PI / 2;
        const minA = (cm / 60) * Math.PI * 2 - Math.PI / 2;
        const secA = (cs / 60) * Math.PI * 2 - Math.PI / 2;
        ctx.lineCap = "round";
        ctx.beginPath(); ctx.moveTo(cx, cy);
        ctx.lineTo(cx + Math.cos(hourA) * S * k[0], cy + Math.sin(hourA) * S * k[0]);
        ctx.strokeStyle = handColor.toString(); ctx.lineWidth = S * k[1]; ctx.stroke();
        ctx.beginPath(); ctx.moveTo(cx, cy);
        ctx.lineTo(cx + Math.cos(minA) * S * k[2], cy + Math.sin(minA) * S * k[2]);
        ctx.strokeStyle = accent.toString(); ctx.lineWidth = S * k[3]; ctx.stroke();
        ctx.beginPath();
        ctx.arc(cx + Math.cos(secA) * S * k[4], cy + Math.sin(secA) * S * k[4], S * k[5], 0, Math.PI * 2);
        ctx.fillStyle = handColor.toString(); ctx.fill();
        ctx.beginPath(); ctx.arc(cx, cy, S * k[6], 0, Math.PI * 2);
        ctx.fillStyle = accent.toString(); ctx.fill();
    }
    onPaint: {
        const ctx = getContext("2d");
        ctx.clearRect(0, 0, width, height);
        if (!analog) return;
        const cx = width / 2, cy = height / 2;
        const R = Math.min(width, height) * 0.48;
        const circle = style === "circle";
        drawFace(ctx, cx, cy, R, circle);
        if (circle) {
            if (showNums) drawNumbers(ctx, cx, cy, R);
            if (showHands) drawHands(ctx, cx, cy, R, [0.52, 0.15, 0.78, 0.045, 0.84, 0.07, 0.08]);
            return;
        }
        if (showHands) {
            ctx.globalAlpha = showNums ? 0.35 : 1.0;
            drawHands(ctx, cx, cy, R * 0.98, [0.44, 0.115, 0.65, 0.095, 0.66, 0.075, 0.06]);
            ctx.globalAlpha = 1;
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: -root.width * 0.027
        visible: root.style === "gear" && root.showNums
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.hourText
            font.family: root.fontFamily; font.weight: Font.Bold
            font.pixelSize: Math.round(root.width * 0.18 * root.fontScale)
            color: root.hourColor
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.minText
            font.family: root.fontFamily; font.weight: Font.Bold
            font.pixelSize: Math.round(root.width * 0.18 * root.fontScale)
            color: root.minuteColor
        }
    }
    Column {
        anchors.centerIn: parent
        spacing: -root.width * 0.09
        opacity: root.style === "digitalV" ? 1 : 0
        visible: opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: 200 } }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.hourText
            font.family: root.fontFamily; font.weight: Font.Bold
            font.pixelSize: Math.round(root.width * 0.42 * root.fontScale)
            color: root.hourColor
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.minText
            font.family: root.fontFamily; font.weight: Font.Bold
            font.pixelSize: Math.round(root.width * 0.42 * root.fontScale)
            color: root.minuteColor
        }
    }
    Row {
        anchors.centerIn: parent
        spacing: root.width * 0.06
        opacity: root.style === "digitalH" ? 1 : 0
        visible: opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: 200 } }
        Text {
            text: root.hourText
            font.family: root.fontFamily; font.weight: Font.Bold
            font.pixelSize: Math.round(root.width * 0.36 * root.fontScale)
            color: root.hourColor
        }
        Text {
            text: root.minText
            font.family: root.fontFamily; font.weight: Font.Bold
            font.pixelSize: Math.round(root.width * 0.36 * root.fontScale)
            color: root.minuteColor
        }
    }
}
