import qs.modules.common
import qs.modules.common.widgets
import QtQuick

Item {
    id: root
    property real s: 250
    property string style: "bubble"
    property var now: new Date()
    property color bg: Appearance.m3colors.m3tertiaryContainer
    property color fg: Appearance.m3colors.m3onTertiaryContainer
    readonly property real k: s / 250

    MaterialShape {
        visible: root.style === "bubble"
        x: 0; y: root.s * 0.02
        implicitSize: root.s * 0.27
        shape: MaterialShape.Shape.Pentagon
        color: root.bg
        StyledText {
            anchors.centerIn: parent
            text: Qt.locale().toString(root.now, "MM")
            font.pixelSize: root.s * 0.092
            font.weight: Font.Bold
            color: root.fg
        }
    }
    MaterialShape {
        visible: root.style === "bubble"
        x: root.s - width; y: root.s - height - root.s * 0.02
        implicitSize: root.s * 0.25
        shape: MaterialShape.Shape.Cookie9Sided
        color: root.bg
        StyledText {
            anchors.centerIn: parent
            text: Qt.locale().toString(root.now, "dd")
            font.pixelSize: root.s * 0.092
            font.weight: Font.Bold
            color: root.fg
        }
    }

    Rectangle {
        readonly property bool outlined: root.style === "border"
        visible: root.style === "rect" || outlined
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.s * 0.68
        width: label.implicitWidth + 22 * root.k
        height: label.implicitHeight + 8 * root.k
        radius: height / 2
        color: outlined ? "transparent" : root.bg
        border.width: outlined ? 2 : 0
        border.color: root.fg
        StyledText {
            id: label
            anchors.centerIn: parent
            text: Qt.locale().toString(root.now, "ddd dd").toUpperCase()
            font.pixelSize: root.s * 0.07
            font.weight: Font.Bold
            color: root.fg
        }
    }
}
