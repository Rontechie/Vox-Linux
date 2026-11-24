import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    property string path: ""            // absolute file path (images only)
    property string text: ""
    property bool isFolder: false
    property bool selected: false
    property real imgHeight: width * 0.62
    signal clicked()

    Layout.fillWidth: true
    implicitHeight: imgHolder.height + label.implicitHeight + 8

    Rectangle {
        id: imgHolder
        anchors { left: parent.left; right: parent.right; top: parent.top }
        height: root.imgHeight
        radius: ma.pressed ? 12 : 22
        color: Appearance.colors.colSurfaceContainerHigh
        Behavior on radius { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

        Item {
            id: clipArea
            anchors.fill: parent
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle { width: clipArea.width; height: clipArea.height; radius: imgHolder.radius }
            }
            Loader {
                anchors.fill: parent
                active: !root.isFolder && root.path.length > 0
                sourceComponent: ThumbnailImage {
                    sourcePath: root.path
                    fillMode: Image.PreserveAspectCrop
                    sourceSize.width: 360
                    sourceSize.height: 240
                }
            }
            MaterialSymbol {
                visible: root.isFolder
                anchors.centerIn: parent
                text: "folder"
                fill: 1
                iconSize: 48
                color: Appearance.colors.colOnSecondaryContainer
            }
            Rectangle {
                anchors.fill: parent
                color: Appearance.m3colors.m3onSurface
                opacity: ma.pressed ? 0.12 : ma.containsMouse ? 0.07 : 0
                Behavior on opacity { NumberAnimation { duration: 120 } }
            }
        }
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: root.selected ? 3 : 1
            border.color: root.selected ? Appearance.colors.colPrimary : Appearance.m3colors.m3outlineVariant
        }
        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.clicked()
        }
    }
    StyledText {
        id: label
        anchors { left: parent.left; right: parent.right; top: imgHolder.bottom; topMargin: 8 }
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideMiddle
        text: root.text
        font.pixelSize: Appearance.font.pixelSize.small
        color: root.selected ? Appearance.colors.colPrimary : Appearance.m3colors.m3onSurface
    }
}
