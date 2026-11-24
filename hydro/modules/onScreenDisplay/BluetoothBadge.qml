import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    required property string name
    required property string icon       // Material symbol for the device (headphones, mouse, ...)
    required property bool connected

    readonly property string message: connected
        ? Translation.tr("Connected to %1").arg(name)
        : Translation.tr("Disconnected from %1").arg(name)

    implicitWidth: badge.implicitWidth + 2 * Appearance.sizes.elevationMargin
    implicitHeight: badge.implicitHeight + 2 * Appearance.sizes.elevationMargin

    opacity: 0
    transform: Translate { id: slide; x: -14 }
    Component.onCompleted: enter.start()
    onMessageChanged: if (opacity > 0) pop.restart()

    ParallelAnimation {
        id: enter
        NumberAnimation { target: root; property: "opacity"; from: 0; to: 1; duration: Appearance.animationCurves.expressiveEffectsDuration }
        NumberAnimation {
            target: slide; property: "x"; from: -14; to: 0
            duration: Appearance.animationCurves.expressiveDefaultSpatialDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.animationCurves.expressiveDefaultSpatial
        }
    }
    SequentialAnimation {
        id: pop
        NumberAnimation { target: badge; property: "scale"; to: 0.94; duration: 80 }
        NumberAnimation {
            target: badge; property: "scale"; to: 1
            duration: Appearance.animationCurves.expressiveFastSpatialDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.animationCurves.expressiveFastSpatial
        }
    }

    StyledRectangularShadow {
        target: badge
    }
    Rectangle {
        id: badge
        anchors {
            fill: parent
            margins: Appearance.sizes.elevationMargin
        }
        radius: 6 // squared-off OSD (was a full pill)
        color: Appearance.colors.colLayer0

        implicitWidth: row.implicitWidth + 10 + 20      // same left / right padding as the volume indicator
        implicitHeight: row.implicitHeight + 2 * 9

        RowLayout {
            id: row
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 10
            }
            spacing: 10

            Item {
                implicitWidth: 34
                implicitHeight: 34
                Layout.alignment: Qt.AlignVCenter

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: root.connected ? Appearance.colors.colPrimaryContainer : Appearance.colors.colSecondaryContainer
                }
                MaterialSymbol {
                    anchors.centerIn: parent
                    text: root.icon
                    iconSize: 22
                    color: root.connected ? Appearance.colors.colOnPrimaryContainer : Appearance.colors.colOnSecondaryContainer
                    renderType: Text.QtRendering
                }
                Rectangle {
                    width: 15
                    height: 15
                    radius: 4
                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                        rightMargin: -3
                        bottomMargin: -3
                    }
                    color: Appearance.colors.colLayer0
                    MaterialSymbol {
                        anchors.centerIn: parent
                        text: root.connected ? "check_circle" : "link_off"
                        iconSize: 14
                        fill: 1
                        color: root.connected ? Appearance.colors.colPrimary : Appearance.colors.colSubtext
                        renderType: Text.QtRendering
                    }
                }
            }

            StyledText {
                Layout.alignment: Qt.AlignVCenter
                Layout.maximumWidth: 300
                text: root.message
                elide: Text.ElideRight
                font.pixelSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer0
            }
        }
    }
}
