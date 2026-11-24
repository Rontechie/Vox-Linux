import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    readonly property var bar: Config.options.bar
    readonly property string style: bar.style
    readonly property int edge: bar.cornerStyle     // 0 hug, 1 float, 2 rectangle
    readonly property bool inset: edge !== 0

    Layout.fillWidth: true
    implicitHeight: 200
    radius: 32
    clip: true
    opacity: 0
    scale: 0.97

    gradient: Gradient {
        GradientStop { position: 0.0; color: Appearance.colors.colPrimaryContainer }
        GradientStop { position: 1.0; color: Appearance.colors.colTertiaryContainer }
    }

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

    MaterialShape {
        shape: MaterialShape.Shape.Cookie12Sided
        implicitSize: 150
        x: parent.width * 0.62
        y: parent.height * 0.18
        color: SettingsTheme.withAlpha(Appearance.colors.colOnPrimaryContainer, 0.09)
        RotationAnimator on rotation { from: 0; to: 360; duration: 80000; loops: Animation.Infinite; running: root.visible }
    }
    MaterialShape {
        shape: MaterialShape.Shape.Flower
        implicitSize: 90
        x: parent.width * 0.08
        y: parent.height * 0.34
        color: SettingsTheme.withAlpha(Appearance.colors.colOnTertiaryContainer, 0.10)
        RotationAnimator on rotation { from: 360; to: 0; duration: 55000; loops: Animation.Infinite; running: root.visible }
    }

    Rectangle {
        width: parent.width * 0.42
        height: parent.height * 0.34
        x: parent.width * 0.29
        y: parent.height * 0.34
        radius: 14
        color: SettingsTheme.withAlpha(Appearance.colors.colLayer1, 0.85)
    }

    component Dot: Rectangle {
        property string widgetStyle: "pills"
        readonly property bool pill: widgetStyle === "pills"
        implicitWidth: pill ? 30 : 10
        implicitHeight: pill ? 20 : 10
        radius: height / 2
        color: pill ? Appearance.colors.colLayer2 : Appearance.colors.colOnLayer0
        opacity: pill ? 1 : 0.55
        Behavior on implicitWidth {
            NumberAnimation { duration: SettingsMotion.spatialMs; easing.type: Easing.BezierSpline; easing.bezierCurve: SettingsMotion.spatial }
        }
        Behavior on implicitHeight {
            NumberAnimation { duration: SettingsMotion.spatialMs; easing.type: Easing.BezierSpline; easing.bezierCurve: SettingsMotion.spatial }
        }
    }
    component Group: Rectangle {
        property string widgetStyle: "pills"
        readonly property bool grouped: widgetStyle === "grouped"
        default property alias dots: row.data
        implicitWidth: row.implicitWidth + (grouped ? 18 : 0)
        implicitHeight: 26
        radius: height / 2
        color: grouped ? Appearance.colors.colLayer1 : "transparent"
        Row {
            id: row
            anchors.centerIn: parent
            spacing: 6
        }
    }

    Rectangle {
        id: strip
        height: 38
        x: root.inset ? 14 : 0
        width: root.width - (root.inset ? 28 : 0)
        y: root.bar.bottom ? root.height - height - (root.inset ? 12 : 0)
                           : (root.inset ? 12 : 0)
        radius: root.edge === 1 ? height / 2 : (root.edge === 2 ? 8 : 0)
        color: root.bar.showBackground ? SettingsTheme.withAlpha(Appearance.colors.colLayer0, 0.94) : "transparent"

        Behavior on x { NumberAnimation { duration: SettingsMotion.spatialMs; easing.type: Easing.BezierSpline; easing.bezierCurve: SettingsMotion.spatial } }
        Behavior on width { NumberAnimation { duration: SettingsMotion.spatialMs; easing.type: Easing.BezierSpline; easing.bezierCurve: SettingsMotion.spatial } }
        Behavior on y { NumberAnimation { duration: SettingsMotion.spatialMs; easing.type: Easing.BezierSpline; easing.bezierCurve: SettingsMotion.spatial } }
        Behavior on radius { NumberAnimation { duration: SettingsMotion.spatialMs; easing.type: Easing.BezierSpline; easing.bezierCurve: SettingsMotion.spatial } }

        RowLayout {
            anchors {
                fill: parent
                leftMargin: 12
                rightMargin: 12
            }
            spacing: 8

            Group {
                widgetStyle: root.style
                Dot { widgetStyle: root.style }
                Dot { widgetStyle: root.style }
            }
            Item { Layout.fillWidth: true }
            Group {
                widgetStyle: root.style
                Dot { widgetStyle: root.style }
                Dot { widgetStyle: root.style }
                Dot { widgetStyle: root.style }
            }
            Item { Layout.fillWidth: true }
            Group {
                widgetStyle: root.style
                Dot { widgetStyle: root.style }
                Dot { widgetStyle: root.style }
            }
        }
    }
}
