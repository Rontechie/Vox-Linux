import QtQuick
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    required property date date
    property real size: 168                 // hour digit pixel size
    readonly property bool use12: /ap/i.test(Config.options.time.format ?? "")
    readonly property int rawHour: date.getHours()
    readonly property string hourStr: String(use12 ? ((rawHour + 11) % 12) + 1 : rawHour).padStart(2, "0")
    readonly property string minuteStr: String(date.getMinutes()).padStart(2, "0")
    readonly property string amPmStr: rawHour < 12 ? "AM" : "PM"

    readonly property real minuteSize: use12 ? size * 0.54 : size

    function topOff(m: TextMetrics): real { return m.tightBoundingRect.y - m.boundingRect.y }

    implicitWidth: hours.implicitWidth + gap + Math.max(minutes.implicitWidth, use12 ? chip.width : 0)
    implicitHeight: hourMetrics.tightBoundingRect.height
    readonly property real gap: size * 0.06

    StyledText {
        id: hours
        y: -root.topOff(hourMetrics)
        text: root.hourStr
        color: Appearance.colors.colPrimary
        font.family: Appearance.font.family.expressive
        font.pixelSize: root.size
        font.weight: Font.DemiBold
        TextMetrics { id: hourMetrics; text: hours.text; font: hours.font }
    }

    StyledText {
        id: minutes
        x: hours.implicitWidth + root.gap
        y: -root.topOff(minuteMetrics)
        text: root.minuteStr
        color: Appearance.colors.colSecondary
        font.family: Appearance.font.family.expressive
        font.pixelSize: root.minuteSize
        font.weight: Font.DemiBold
        TextMetrics { id: minuteMetrics; text: minutes.text; font: minutes.font }
    }

    Rectangle {
        id: chip
        visible: root.use12
        x: minutes.x
        anchors.bottom: parent.bottom
        width: minutes.implicitWidth
        height: amPm.implicitHeight + root.size * 0.12
        radius: height * 0.35
        color: Appearance.colors.colLayer2
        StyledText {
            id: amPm
            anchors.centerIn: parent
            text: root.amPmStr
            color: Appearance.colors.colOnLayer2
            font.family: Appearance.font.family.expressive
            font.pixelSize: root.size * 0.2
            font.weight: Font.DemiBold
        }
    }
}
