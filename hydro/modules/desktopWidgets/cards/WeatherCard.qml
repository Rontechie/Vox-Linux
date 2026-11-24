import QtQuick
import QtQuick.Layouts
import qs.modules.desktopWidgets.ui
import qs.modules.desktopWidgets.widgets

ExprDesktopWidget {
    id: card
    wType: "weather"
    baseW: 360
    baseH: 340

    face: Component {
        HwCard {
            id: wc
            readonly property bool cloudy: [119, 122, 143, 248, 260].indexOf(HwWeather.code) >= 0
            readonly property bool clear: HwWeather.code === 113
            property real wavePhase: 0
            FrameAnimation {
                running: card.live && HwConfig.weather.waveEffect
                onTriggered: wc.wavePhase = (wc.wavePhase + frameTime * 2.4) % (Math.PI * 2)
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14

                    Item {
                        Layout.preferredWidth: 72
                        Layout.preferredHeight: 72
                        SunShape { anchors.centerIn: parent; size: 64; visible: wc.clear && HwWeather.isDay }
                        MoonShape { anchors.centerIn: parent; size: 58; visible: wc.clear && !HwWeather.isDay }
                        CloudShape { anchors.centerIn: parent; visible: !wc.clear; colorBody: HwM3.alpha("#FFFFFF", 0.9) }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Text {
                            text: HwWeather.valid ? HwWeather.temp : "—"
                            font.family: HwState.fontPrimary
                            font.pixelSize: Math.round(40 * HwState.fontScale)
                            font.weight: Font.Bold
                            color: HwPal.colorOnSurface
                        }
                        Text {
                            Layout.fillWidth: true
                            text: HwWeather.valid ? HwState.weatherText(HwWeather.desc) : HwState.tr("weather_loading")
                            elide: Text.ElideRight
                            font.family: HwState.fontSecondary
                            font.pixelSize: Math.round(14 * HwState.fontScale)
                            color: HwM3.primary
                        }
                        Text {
                            Layout.fillWidth: true
                            text: HwWeather.city
                            elide: Text.ElideRight
                            font.family: HwState.fontSecondary
                            font.pixelSize: Math.round(12 * HwState.fontScale)
                            color: HwPal.muted
                        }
                    }
                }

                WeatherStatBar {
                    Layout.fillWidth: true
                    label: HwState.tr("Humidity")
                    valueText: HwWeather.humidity + "%"
                    pct: HwWeather.humidity / 100
                    colorPrimary: HwM3.primary
                    colorOnSurfVar: HwPal.colorOnSurface
                    trackColor: HwM3.ringTrack
                    waveEffect: HwConfig.weather.waveEffect
                    wavePhase: wc.wavePhase
                }
                WeatherStatBar {
                    Layout.fillWidth: true
                    label: HwState.tr("Wind")
                    valueText: HwWeather.windKmh + " km/h"
                    pct: Math.min(1, HwWeather.windKmh / 60)
                    colorPrimary: HwM3.primary
                    colorOnSurfVar: HwPal.colorOnSurface
                    trackColor: HwM3.ringTrack
                    waveEffect: HwConfig.weather.waveEffect
                    wavePhase: wc.wavePhase
                }

                WeatherForecastRow {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    days: HwWeather.days
                    shapedCards: HwConfig.weather.shapedCards
                    colorPrimary: HwM3.primary
                    colorOnSurfVar: HwPal.colorOnSurface
                    colorTextSecondary: HwPal.muted
                    cardBg: HwM3.secondaryContainer
                    todayLabel: HwState.tr("Today")
                    tomorrowLabel: HwState.tr("Tomorrow")
                }
            }
        }
    }
}
