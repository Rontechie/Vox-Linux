import QtQuick
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    implicitHeight: 36
    implicitWidth: batteryRow.implicitWidth + 24
    radius: 18
    color: Qt.rgba(1, 1, 1, 0.12)
    Row {
        id: batteryRow
        anchors.centerIn: parent
        spacing: 6
        MaterialSymbol {
            text: Battery.isCharging ? "battery_charging_full" : (Battery.isLow ? "battery_alert" : "battery_full")
            iconSize: 20
            fill: 1
            color: (Battery.isLow && !Battery.isCharging) ? Appearance.m3colors.m3error : "white"
            anchors.verticalCenter: parent.verticalCenter
        }
        StyledText {
            text: Math.round(Battery.percentage * 100) + "%"
            font.pixelSize: Appearance.font.pixelSize.small
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
