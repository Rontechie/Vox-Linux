import QtQuick
import qs.services
import qs.modules.common

Text {
    visible: Battery.available
    readonly property string icon: String.fromCodePoint(
        Battery.isCharging ? 0xF0084 : (Battery.isLow ? 0xF007A : 0xF0079))
    text: icon + " " + Math.round(Battery.percentage * 100) + "%"
    color: (Battery.isLow && !Battery.isPluggedIn) ? Theme.warn : Theme.fg
    font.family: Theme.mono
    font.pixelSize: Theme.fontSize
}
