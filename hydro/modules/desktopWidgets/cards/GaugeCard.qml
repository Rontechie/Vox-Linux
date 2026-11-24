import QtQuick
import qs.services
import qs.modules.desktopWidgets.ui
import qs.modules.desktopWidgets.widgets
import "../ui/SvgPaths.js" as SvgPaths

ExprDesktopWidget {
    id: card
    wType: "gauge"
    baseW: 200
    baseH: 200

    face: Component {
        Item {
            id: g
            readonly property bool cpu: HwConfig.gauge.metric === "cpu"
            readonly property real pct: cpu ? ResourceUsage.cpuUsage : ResourceUsage.memoryUsedPercentage
            property real wavePhase: 0
            FrameAnimation {
                running: card.live && HwConfig.gauge.waveEffect
                onTriggered: g.wavePhase = (g.wavePhase + frameTime * 2.2) % (Math.PI * 2)
            }
            ShapeGauge {
                anchors.fill: parent
                shapePath: SvgPaths[HwConfig.gauge.shape] ?? SvgPaths.squircle
                pct: g.pct
                fillColor: HwM3.primaryContainer
                emptyColor: HwM3.surfaceContainer
                outlineColor: HwM3.alpha(HwM3.inkSurface, 0.25)
                waveEffect: HwConfig.gauge.waveEffect
                wavePhase: g.wavePhase
                fillMin: 8
                fillMax: 92
            }
            Column {
                anchors.centerIn: parent
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Math.round(g.pct * 100) + "%"
                    font.family: HwState.fontPrimary
                    font.pixelSize: Math.round(g.width * 0.22 * HwState.fontScale)
                    font.weight: Font.Black
                    color: HwM3.inkPrimaryContainer
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: g.cpu ? "CPU" : "RAM"
                    font.family: HwState.fontSecondary
                    font.pixelSize: Math.round(g.width * 0.09 * HwState.fontScale)
                    color: HwM3.inkPrimaryContainer
                    opacity: 0.8
                }
            }
        }
    }
}
