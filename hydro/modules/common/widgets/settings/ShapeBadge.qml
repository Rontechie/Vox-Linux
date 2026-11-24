import QtQuick
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    property var shape: MaterialShape.Shape.Cookie6Sided
    property string icon: ""
    property real size: 48
    property color color: Appearance.colors.colSecondaryContainer
    property color iconColor: Appearance.colors.colOnSecondaryContainer
    property bool active: false

    implicitWidth: size
    implicitHeight: size

    MaterialShape {
        anchors.centerIn: parent
        shape: root.shape
        implicitSize: root.size
        color: root.color
        rotation: root.active ? 24 : 0
        scale: root.active ? 1.1 : 1
        Behavior on rotation {
            NumberAnimation {
                duration: SettingsMotion.spatialMs
                easing.type: Easing.BezierSpline
                easing.bezierCurve: SettingsMotion.spatial
            }
        }
        Behavior on scale {
            NumberAnimation {
                duration: SettingsMotion.fastSpatialMs
                easing.type: Easing.BezierSpline
                easing.bezierCurve: SettingsMotion.fastSpatial
            }
        }
    }
    MaterialSymbol {
        anchors.centerIn: parent
        visible: root.icon !== ""
        text: root.icon
        iconSize: root.size * 0.46
        color: root.iconColor
    }
}
