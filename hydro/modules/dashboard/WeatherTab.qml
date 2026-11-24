import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.bar.weather
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 6
        spacing: 12

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: hero.implicitHeight + 32
            radius: Appearance.rounding.large
            color: Appearance.colors.colLayer1
            RowLayout {
                id: hero
                anchors.centerIn: parent
                spacing: 16
                MaterialSymbol {
                    text: Icons.getWeatherIcon(Weather.data.wCode) ?? "cloud"
                    iconSize: 64
                    color: Appearance.colors.colOnLayer1
                }
                ColumnLayout {
                    spacing: 0
                    StyledText {
                        text: Weather.data.temp
                        font.pixelSize: 40
                        color: Appearance.colors.colOnLayer1
                    }
                    StyledText {
                        text: Weather.data.city + "  •  " + Translation.tr("feels like %1").arg(Weather.data.tempFeelsLike)
                        color: Appearance.colors.colSubtext
                    }
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            columnSpacing: 8
            rowSpacing: 8
            WeatherCard { title: Translation.tr("Humidity"); symbol: "water_drop"; value: Weather.data.humidity }
            WeatherCard { title: Translation.tr("Wind"); symbol: "air"; value: Weather.data.wind + " " + Weather.data.windDir }
            WeatherCard { title: Translation.tr("Precipitation"); symbol: "rainy_light"; value: Weather.data.precip }
            WeatherCard { title: Translation.tr("UV"); symbol: "wb_sunny"; value: Weather.data.uv }
            WeatherCard { title: Translation.tr("Pressure"); symbol: "speed"; value: Weather.data.press }
            WeatherCard { title: Translation.tr("Visibility"); symbol: "visibility"; value: Weather.data.visib }
            WeatherCard { title: Translation.tr("Sunrise"); symbol: "wb_twilight"; value: Weather.data.sunrise }
            WeatherCard { title: Translation.tr("Sunset"); symbol: "bedtime"; value: Weather.data.sunset }
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            color: Appearance.colors.colSubtext
            font.pixelSize: Appearance.font.pixelSize.smaller
            text: Translation.tr("Updated %1").arg(Weather.data.lastRefresh)
        }

        Item { Layout.fillHeight: true }
    }
}
