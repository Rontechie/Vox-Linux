import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.modules.common
import qs.modules.bar.faces

Item {
    id: root
    implicitWidth: pill.visible ? pill.implicitWidth : 0
    implicitHeight: pill.implicitHeight

    readonly property var cfg: Config.options.bar.mediaFace
    readonly property var player: face.player
    readonly property real length: player?.length ?? 0
    readonly property real position: player?.position ?? 0
    readonly property real progress: length > 0 ? Math.max(0, Math.min(1, position / length)) : 0

    HydroPill {
        id: pill
        clickable: false
        hPadding: 0 // the face pads itself
        visible: face.shown

        MediaFace {
            id: face
            Layout.alignment: Qt.AlignVCenter
        }
    }

    ClippingRectangle {
        id: tank
        anchors.fill: pill
        radius: pill.radius
        color: "transparent"
        visible: pill.visible && root.cfg.liquid && face.isMediaActive
        z: 5

        property real edge: root.progress * width
        Behavior on edge { NumberAnimation { duration: 900; easing.type: Easing.Linear } }
        property real phase: 0
        NumberAnimation on phase {
            from: 0; to: Math.PI * 2
            duration: 2600
            loops: Animation.Infinite
            running: tank.visible && face.isPlaying
        }
        onPhaseChanged: wave.requestPaint()
        onEdgeChanged: wave.requestPaint()
        onWidthChanged: wave.requestPaint()

        Canvas {
            id: wave
            anchors.fill: parent
            readonly property color liquid: Appearance.colors.colPrimary
            onLiquidChanged: requestPaint()
            onPaint: {
                const ctx = getContext("2d");
                ctx.reset();
                if (tank.edge <= 0.5) return;
                const h = height, amp = Math.max(1.5, h * 0.09);
                const op = root.cfg.liquidOpacity;
                const layers = [ { shift: 4, ph: -1.6, a: op * 0.55, k: 0.30 }, { shift: 0, ph: 0, a: op, k: 0.22 } ];
                for (const L of layers) {
                    ctx.beginPath();
                    const e = Math.min(width, tank.edge + L.shift);
                    ctx.moveTo(0, 0);
                    ctx.lineTo(e, 0);
                    for (let y = 0; y <= h; y += 2)
                        ctx.lineTo(Math.min(width, e + amp * Math.sin(y * L.k + tank.phase + L.ph)), y);
                    ctx.lineTo(0, h);
                    ctx.closePath();
                    ctx.fillStyle = Qt.rgba(liquid.r, liquid.g, liquid.b, L.a);
                    ctx.fill();
                }
            }
        }
    }
}
