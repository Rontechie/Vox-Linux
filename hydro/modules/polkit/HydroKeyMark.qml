import QtQuick
import qs.modules.common

Canvas {
    id: root
    property color hexColor: Appearance.m3colors.m3primaryContainer
    property color holeColor: Appearance.m3colors.m3surfaceContainerHigh
    property real angle: 0 // degrees, the blades turn by this much

    implicitWidth: 104
    implicitHeight: 104
    antialiasing: true

    onAngleChanged: requestPaint()
    onHexColorChanged: requestPaint()
    onHoleColorChanged: requestPaint()
    onWidthChanged: requestPaint()
    Component.onCompleted: requestPaint()

    function blade() {
        const n = 7, r0 = 9, r1 = 46, sweep = 56, w = 9, e = 0.6;
        const left = [], right = [];
        function cl(t) {
            const r = r0 + (r1 - r0) * t, a = (-90 + sweep * Math.pow(t, 1.2)) * Math.PI / 180;
            return [r * Math.cos(a), r * Math.sin(a)];
        }
        for (let i = 0; i <= n; i++) {
            const t = i / n;
            const p = cl(t), q = cl(Math.min(1, t + 0.03)), q0 = cl(Math.max(0, t - 0.03));
            let tx = q[0] - q0[0], ty = q[1] - q0[1];
            const L = Math.hypot(tx, ty);
            tx /= L; ty /= L;
            const nx = -ty, ny = tx;
            const wt = i === 0 ? 1.4 : w * Math.sin(Math.PI * Math.pow(t, e));
            left.push([p[0] + nx * wt, p[1] + ny * wt]);
            right.push([p[0] - nx * wt, p[1] - ny * wt]);
        }
        return left.concat(right.reverse().slice(1));
    }

    onPaint: {
        const ctx = getContext("2d");
        ctx.reset();
        const s = Math.min(width, height) / 128;
        ctx.save();
        ctx.translate(width / 2, height / 2);
        ctx.scale(s, s);

        ctx.beginPath();
        for (let k = 0; k < 6; k++) {
            const a = (-90 + 60 * k) * Math.PI / 180;
            const x = 60 * Math.cos(a), y = 60 * Math.sin(a);
            if (k === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
        }
        ctx.closePath();
        ctx.fillStyle = root.hexColor;
        ctx.fill();

        const b = root.blade();
        ctx.fillStyle = root.holeColor;
        for (let k = 0; k < 6; k++) {
            ctx.save();
            ctx.rotate((60 * k + root.angle) * Math.PI / 180);
            ctx.beginPath();
            ctx.moveTo(b[0][0], b[0][1]);
            for (let i = 1; i < b.length; i++) ctx.lineTo(b[i][0], b[i][1]);
            ctx.closePath();
            ctx.fill();
            ctx.restore();
        }
        ctx.restore();
    }
}
