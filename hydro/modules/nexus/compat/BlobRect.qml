import QtQuick

Rectangle {
    property var group: null
    color: group ? group.color : "transparent"
    property real deformScale: 1
}
