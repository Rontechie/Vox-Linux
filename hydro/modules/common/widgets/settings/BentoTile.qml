import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    property string title: ""
    property string subtitle: ""
    property string icon: ""
    property var shape: MaterialShape.Shape.Cookie6Sided
    property bool interactive: true
    property int order: 0
    signal clicked()

    Layout.fillWidth: true
    implicitHeight: 96
    radius: (area.containsMouse && interactive) ? 36 : 24
    color: (area.containsMouse && interactive) ? Appearance.colors.colLayer2Hover : Appearance.colors.colLayer2
    border.width: 1
    border.color: SettingsTheme.withAlpha(SettingsTheme.outline, 0.5)
    scale: area.pressed ? 0.97 : 1
    opacity: 0
    transform: Translate { id: lift; y: 14 }

    Behavior on radius {
        NumberAnimation {
            duration: SettingsMotion.spatialMs
            easing.type: Easing.BezierSpline
            easing.bezierCurve: SettingsMotion.spatial
        }
    }
    Behavior on color { ColorAnimation { duration: SettingsMotion.effectsMs } }
    Behavior on scale {
        NumberAnimation {
            duration: SettingsMotion.fastSpatialMs
            easing.type: Easing.BezierSpline
            easing.bezierCurve: SettingsMotion.fastSpatial
        }
    }

    Component.onCompleted: enter.start()
    SequentialAnimation {
        id: enter
        PauseAnimation { duration: Math.min(root.order * 40, 400) }
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; from: 0; to: 1; duration: SettingsMotion.effectsMs + 80 }
            NumberAnimation {
                target: lift; property: "y"; from: 14; to: 0
                duration: SettingsMotion.spatialMs
                easing.type: Easing.BezierSpline
                easing.bezierCurve: SettingsMotion.spatial
            }
        }
    }

    RowLayout {
        anchors {
            fill: parent
            margins: 16
        }
        spacing: 14

        ShapeBadge {
            size: 52
            shape: root.shape
            icon: root.icon
            active: area.containsMouse && root.interactive
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            StyledText {
                Layout.fillWidth: true
                text: root.title
                elide: Text.ElideRight
                font.pixelSize: SettingsTheme.fontSizeLarge
                font.weight: Font.Medium
                color: Appearance.colors.colOnLayer1
            }
            StyledText {
                Layout.fillWidth: true
                visible: text !== ""
                text: root.subtitle
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
                font.pixelSize: SettingsTheme.fontSizeSmall
                color: Appearance.colors.colSubtext
            }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.interactive
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
