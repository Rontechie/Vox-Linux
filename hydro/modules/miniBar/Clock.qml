import Quickshell
import QtQuick
import qs.modules.common

Text {
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    text: Qt.formatDateTime(clock.date, "ddd d MMM  HH:mm")
    color: Theme.fg
    font.family: Theme.mono
    font.pixelSize: Theme.fontSize
}
