import QtQuick
import qs.modules.desktopWidgets.ui
import qs.modules.desktopWidgets.widgets

Item {
    id: layer

    DesktopCavaVis {
        anchors.fill: parent
        visible: HwConfig.cava.enable && !HwState.lockScreenActive
    }

    MediaCard {}
    PlayerCard {}
    LyricsCard {}
    WeatherCard {}
    SystemCard {}
    GaugeCard {}
    StopwatchCard {}
}
