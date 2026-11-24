import qs.modules.common
import qs.modules.common.widgets
import QtQuick

Column {
    id: root
    property real s: 250
    property string hourText: "00"
    property string minuteText: "00"
    property string ampmText: ""
    property bool showAmPm: false
    property color tint: "gray"

    spacing: -s * 0.075
    StyledText {
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.hourText
        font.pixelSize: root.s * 0.27
        font.weight: Font.Bold
        color: root.tint
    }
    StyledText {
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.minuteText
        font.pixelSize: root.s * 0.27
        font.weight: Font.Bold
        color: root.tint
    }
    StyledText {
        visible: root.showAmPm
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.ampmText
        font.pixelSize: root.s * 0.09
        font.weight: Font.Bold
        color: root.tint
    }
}
