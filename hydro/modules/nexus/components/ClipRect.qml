import QtQuick

Item {
    id: root

    property real radius
    property real topLeftRadius: radius
    property real topRightRadius: radius
    property real bottomRightRadius: radius
    property real bottomLeftRadius: radius
    property color color: "transparent"
    default property alias contentData: contentItem.data

    clip: true

    Rectangle {
        anchors.fill: parent
        color: root.color
        topLeftRadius: root.topLeftRadius
        topRightRadius: root.topRightRadius
        bottomLeftRadius: root.bottomLeftRadius
        bottomRightRadius: root.bottomRightRadius
    }

    Item {
        id: contentItem

        anchors.fill: parent
    }
}
