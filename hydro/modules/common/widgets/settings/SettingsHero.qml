import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    property string title: ""
    property string subtitle: ""
    property string icon: ""
    property url logo: ""
    property var shapeA: MaterialShape.Shape.Cookie9Sided
    property var shapeB: MaterialShape.Shape.Sunny
    property var shapeC: MaterialShape.Shape.Clover4Leaf
    property color tint: Appearance.colors.colPrimaryContainer
    property color onTint: Appearance.colors.colOnPrimaryContainer
    property bool tall: false
    default property alias extra: extraRow.data

    Layout.fillWidth: true
    implicitHeight: tall ? 230 : 150
    radius: 32
    color: tint
    clip: true
    opacity: 0
    scale: 0.97

    Component.onCompleted: enter.start()
    ParallelAnimation {
        id: enter
        NumberAnimation { target: root; property: "opacity"; from: 0; to: 1; duration: SettingsMotion.effectsMs + 100 }
        NumberAnimation {
            target: root; property: "scale"; from: 0.97; to: 1
            duration: SettingsMotion.spatialMs
            easing.type: Easing.BezierSpline
            easing.bezierCurve: SettingsMotion.spatial
        }
    }

    Item {
        id: deco
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        width: Math.min(parent.width * 0.45, 320)

        MaterialShape {
            shape: root.shapeA
            implicitSize: root.height * 1.2
            x: deco.width - width * 0.6
            anchors.verticalCenter: parent.verticalCenter
            color: SettingsTheme.withAlpha(root.onTint, 0.10)
            RotationAnimator on rotation { from: 0; to: 360; duration: 70000; loops: Animation.Infinite; running: root.visible }
        }
        MaterialShape {
            shape: root.shapeB
            implicitSize: 70
            x: deco.width * 0.32
            y: deco.height * 0.16
            color: SettingsTheme.withAlpha(root.onTint, 0.20)
            RotationAnimator on rotation { from: 360; to: 0; duration: 34000; loops: Animation.Infinite; running: root.visible }
        }
        MaterialShape {
            shape: root.shapeC
            implicitSize: 36
            x: deco.width * 0.14
            y: deco.height * 0.66
            color: SettingsTheme.withAlpha(root.onTint, 0.28)
            RotationAnimator on rotation { from: 0; to: 360; duration: 22000; loops: Animation.Infinite; running: root.visible }
        }
    }

    ColumnLayout {
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: 28
            rightMargin: 28
        }
        spacing: 8

        RowLayout {
            spacing: 14
            Image {
                visible: root.logo != ""
                source: root.logo
                sourceSize: Qt.size(64, 64)
                Layout.preferredWidth: visible ? 64 : 0
                Layout.preferredHeight: visible ? 64 : 0
            }
            ShapeBadge {
                visible: root.icon !== "" && root.logo == ""
                size: 46
                shape: MaterialShape.Shape.Cookie6Sided
                icon: root.icon
                color: root.onTint
                iconColor: root.tint
            }
            StyledText {
                text: root.title
                font.family: Appearance.font.family.expressive
                font.pixelSize: root.tall ? 42 : 30
                font.weight: Font.Bold
                color: root.onTint
            }
        }
        StyledText {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width * 0.58
            visible: text !== ""
            text: root.subtitle
            wrapMode: Text.WordWrap
            font.pixelSize: SettingsTheme.fontSizeMedium
            color: SettingsTheme.withAlpha(root.onTint, 0.82)
        }
        RowLayout {
            id: extraRow
            spacing: 10
        }
    }
}
