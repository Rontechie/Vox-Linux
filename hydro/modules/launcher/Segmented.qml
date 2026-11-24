import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import QtQuick.Layouts

Item {
    id: sg
    property var pal
    property var model: []
    property int current: 0
    signal picked(int i)
    implicitHeight: 36
    Layout.fillWidth: true
    Rectangle { anchors.fill: parent; radius: height / 2; color: sg.pal.containerHighest }
    Rectangle {
        width: sg.width / Math.max(1, sg.model.length); height: parent.height; radius: height / 2
        x: sg.current * width; color: sg.pal.primary
        Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutBack; easing.overshoot: 1.1 } }
    }
    Row {
        Repeater {
            model: sg.model
            delegate: Item {
                width: sg.width / sg.model.length; height: sg.height
                StyledText {
                    anchors.centerIn: parent; text: modelData; font.pixelSize: 12; font.bold: true
                    color: sg.current === index ? sg.pal.fgOnPrimary : sg.pal.fg
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sg.picked(index) }
            }
        }
    }
}
