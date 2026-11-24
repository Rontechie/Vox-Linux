import QtQuick

Rectangle {
    property var group: null
    color: group ? group.color : "transparent"
    property real borderLeft: 0
    property real borderRight: 0
    property real borderTop: 0
    property real borderBottom: 0
}
