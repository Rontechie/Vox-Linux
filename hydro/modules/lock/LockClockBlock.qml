import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.background.clock

ColumnLayout {
    id: root
    required property date date
    required property var lay
    property int textAlign: Qt.AlignHCenter
    property real screenHeight: 1080
    spacing: 6

        Rectangle { // "locked" pill
            visible: Config.options.lock.showLockedText
            Layout.alignment: root.textAlign
            implicitHeight: 30
            implicitWidth: lockedRow.implicitWidth + 24
            radius: 15
            color: Qt.rgba(1, 1, 1, 0.12)
            Row {
                id: lockedRow
                anchors.centerIn: parent
                spacing: 6
                MaterialSymbol { text: "lock"; iconSize: 16; fill: 1; color: "white"; anchors.verticalCenter: parent.verticalCenter }
                StyledText {
                    text: Translation.tr("Locked")
                    font.family: Appearance.font.family.monospace
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    font.letterSpacing: 2
                    font.capitalization: Font.AllUppercase
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        StyledText {
            Layout.alignment: root.textAlign
            text: Qt.formatDateTime(root.date, Config.options.time.format)
            font.family: Appearance.font.family.expressive
            visible: root.lay.clock.style === "digital" || (root.lay.clock.style !== "cookie" && root.lay.clock.style !== "stacked")
            font.pixelSize: Math.min(root.lay.clock.size, root.screenHeight * 0.25)
            font.weight: Font.Medium
            color: "white"
        }
        StackedClock {
            visible: root.lay.clock.style === "stacked"
            Layout.alignment: root.textAlign
            date: root.date
            size: Math.min(root.lay.clock.size, root.screenHeight * 0.25)
        }
        CookieClock {
            visible: root.lay.clock.style === "cookie"
            Layout.alignment: root.textAlign
            size: root.lay.clock.cookieSize
        }
        StyledText {
            visible: root.lay.clock.showDate
            Layout.alignment: root.textAlign
            text: Qt.formatDateTime(root.date, "dddd · d MMMM")
            font.family: Appearance.font.family.monospace
            font.pixelSize: Appearance.font.pixelSize.normal
            font.letterSpacing: 3
            font.capitalization: Font.AllUppercase
            color: Qt.rgba(1, 1, 1, 0.75)
        }
}
