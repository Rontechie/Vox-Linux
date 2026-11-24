import qs
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import Quickshell

Item {
    id: root
    readonly property var ck: Config.options.background.widgets.clock.cookie
    readonly property var sh: Config.options.background.widgets.clock.shadow
    property real size: ck.size
    readonly property real k: size / 250
    implicitWidth: size
    implicitHeight: size

    SystemClock {
        id: clock
        precision: (root.ck.secondHandStyle !== "hide" || GlobalStates.screenLocked)
            ? SystemClock.Seconds : SystemClock.Minutes
    }
    readonly property int seconds: clock.date.getSeconds()
    readonly property real minutes: clock.date.getMinutes() + seconds / 60
    readonly property real hours: (clock.date.getHours() % 12) + minutes / 60

    readonly property bool use12: /ap/i.test(Config.options.time.format ?? "")
    readonly property int rawHour: clock.date.getHours()
    readonly property string hourText: String(use12 ? ((rawHour + 11) % 12) + 1 : rawHour).padStart(2, "0")
    readonly property string minuteText: String(clock.date.getMinutes()).padStart(2, "0")
    readonly property string ampmText: rawHour < 12 ? "am" : "pm"

    readonly property string bodyKey: ck.bodyColor
    readonly property color bodyBase: {
        switch (bodyKey) {
        case "primaryContainer": return Appearance.m3colors.m3primaryContainer;
        case "tertiaryContainer": return Appearance.m3colors.m3tertiaryContainer;
        case "surfaceContainer": return Appearance.m3colors.m3surfaceContainerHigh;
        default: return Appearance.m3colors.m3secondaryContainer;
        }
    }
    readonly property color onBody: {
        switch (bodyKey) {
        case "primaryContainer": return Appearance.m3colors.m3onPrimaryContainer;
        case "tertiaryContainer": return Appearance.m3colors.m3onTertiaryContainer;
        case "surfaceContainer": return Appearance.m3colors.m3onSurface;
        default: return Appearance.m3colors.m3onSecondaryContainer;
        }
    }

    CookieBody {
        visible: root.sh.enable
        anchors.centerIn: parent
        anchors.verticalCenterOffset: root.sh.offset * root.k
        bodySize: root.size * 0.9
        sides: root.ck.sides
        sine: root.ck.useSineCookie
        color: Qt.alpha(Appearance.m3colors.m3shadow, root.sh.opacity)
    }
    CookieBody {
        anchors.centerIn: parent
        bodySize: root.size * 0.9
        sides: root.ck.sides
        sine: root.ck.useSineCookie
        spin: root.ck.constantlyRotate
        color: Qt.alpha(root.bodyBase, root.ck.bodyOpacity)
    }

    ClockDial {
        anchors.fill: parent
        s: root.size
        style: root.ck.dialNumberStyle
        hourMarks: root.ck.hourMarks
        markColor: root.onBody
    }

    TimeColumn {
        visible: root.ck.timeIndicators && root.ck.dialNumberStyle !== "numbers"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: root.use12 ? 2 : 0
        s: root.size
        hourText: root.hourText
        minuteText: root.minuteText
        ampmText: root.ampmText
        showAmPm: root.use12
        tint: Qt.alpha(root.onBody, 0.38)
    }

    DateIndicator {
        visible: root.ck.dateInClock
        anchors.fill: parent
        s: root.size
        style: root.ck.dateStyle
        now: clock.date
        bg: root.bodyKey === "tertiaryContainer" ? Appearance.m3colors.m3secondaryContainer : Appearance.m3colors.m3tertiaryContainer
        fg: root.bodyKey === "tertiaryContainer" ? Appearance.m3colors.m3onSecondaryContainer : Appearance.m3colors.m3onTertiaryContainer
    }

    HourHand {
        anchors.fill: parent
        s: root.size
        hours: root.hours
        style: root.ck.hourHandStyle
        fillColor: Appearance.m3colors.m3tertiary
        lineColor: Appearance.m3colors.m3primary
    }
    MinuteHand {
        anchors.fill: parent
        s: root.size
        minutes: root.minutes
        style: root.ck.minuteHandStyle
        color: Appearance.m3colors.m3primary
    }
    SecondHand {
        anchors.fill: parent
        s: root.size
        seconds: root.seconds
        style: root.ck.secondHandStyle
        color: Appearance.m3colors.m3primary
        dotColor: root.ck.secondHandStyle === "dot" ? root.onBody : Appearance.m3colors.m3primary
    }

    Rectangle {
        anchors.centerIn: parent
        width: 14 * root.k; height: width; radius: width / 2
        color: root.bodyBase
        border.width: 3 * root.k
        border.color: Appearance.m3colors.m3primary
    }
}
