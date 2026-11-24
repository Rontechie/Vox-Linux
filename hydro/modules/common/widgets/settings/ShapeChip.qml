import QtQuick
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    property string label: ""
    property string icon: ""
    property var shape: MaterialShape.Shape.Cookie6Sided
    property bool selected: false
    signal clicked()

    implicitWidth: 120
    implicitHeight: 120
    scale: area.pressed ? 0.95 : 1
    Behavior on scale {
        NumberAnimation {
            duration: SettingsMotion.fastSpatialMs
            easing.type: Easing.BezierSpline
            easing.bezierCurve: SettingsMotion.fastSpatial
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: root.selected ? 44 : 22
        color: root.selected ? Appearance.colors.colPrimaryContainer
             : area.containsMouse ? Appearance.colors.colLayer2Hover : Appearance.colors.colLayer2
        Behavior on radius {
            NumberAnimation {
                duration: SettingsMotion.spatialMs
                easing.type: Easing.BezierSpline
                easing.bezierCurve: SettingsMotion.spatial
            }
        }
        Behavior on color { ColorAnimation { duration: SettingsMotion.effectsMs } }
    }

    Column {
        anchors.centerIn: parent
        spacing: 8
        ShapeBadge {
            anchors.horizontalCenter: parent.horizontalCenter
            size: 48
            shape: root.shape
            icon: root.icon
            active: root.selected || area.containsMouse
            color: root.selected ? Appearance.colors.colPrimary : Appearance.colors.colSecondaryContainer
            iconColor: root.selected ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSecondaryContainer
        }
        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            font.pixelSize: SettingsTheme.fontSizeSmall
            font.weight: root.selected ? Font.Medium : Font.Normal
            color: root.selected ? Appearance.colors.colOnPrimaryContainer : Appearance.colors.colOnLayer1
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
