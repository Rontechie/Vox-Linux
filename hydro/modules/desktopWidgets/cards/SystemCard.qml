import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.desktopWidgets.ui
import qs.modules.desktopWidgets.widgets

ExprDesktopWidget {
    id: card
    wType: "system"
    baseW: 440
    baseH: 160

    face: Component {
        HwCard {
            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 8

                StatGearRing {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    pct: ResourceUsage.cpuUsage
                    label: "CPU"
                    valueText: Math.round(ResourceUsage.cpuUsage * 100) + "%"
                    running: card.live
                    ringColor: HwM3.primary
                    trackColor: HwM3.ringTrack
                    labelColor: HwPal.muted
                    valueColor: HwPal.colorOnSurface
                }
                StatGearRing {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    pct: ResourceUsage.memoryUsedPercentage
                    label: "RAM"
                    valueText: Math.round(ResourceUsage.memoryUsedPercentage * 100) + "%"
                    running: card.live
                    phaseOffset: 1.2
                    ringColor: HwM3.primary
                    trackColor: HwM3.ringTrack
                    labelColor: HwPal.muted
                    valueColor: HwPal.colorOnSurface
                }
                LoadBlob {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    value: Math.round(ResourceUsage.swapUsedPercentage * 100)
                    label: "SWAP"
                    live: card.live
                }
            }
        }
    }
}
