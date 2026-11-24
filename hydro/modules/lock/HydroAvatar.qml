import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    property bool busy: false
    property bool failed: false
    property bool open: false
    property color badgeEdge: Appearance.m3colors.m3surfaceContainerHigh
    readonly property string user: Quickshell.env("USER") ?? ""
    readonly property bool hasPhoto: face.status === Image.Ready || accounts.status === Image.Ready

    implicitWidth: 108
    implicitHeight: 108

    function wiggle() { wiggleAnim.restart() }

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "transparent"
        border.width: 3
        border.color: root.failed ? Appearance.m3colors.m3error : Appearance.colors.colPrimary
        opacity: root.busy ? 0.25 : 1
        Behavior on opacity { NumberAnimation { duration: 200 } }
        Behavior on border.color { ColorAnimation { duration: 200 } }
    }
    Canvas {
        anchors.fill: parent
        visible: root.busy
        onVisibleChanged: requestPaint()
        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            ctx.lineWidth = 3;
            ctx.lineCap = "round";
            ctx.strokeStyle = Appearance.colors.colPrimary;
            ctx.beginPath();
            ctx.arc(width / 2, height / 2, width / 2 - 1.5, 0, Math.PI * 0.6);
            ctx.stroke();
        }
        RotationAnimator on rotation { running: root.busy; from: 0; to: 360; duration: 1100; loops: Animation.Infinite }
    }

    Item {
        id: pic
        anchors.fill: parent
        anchors.margins: 9
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: pic.width
                height: pic.height
                radius: width / 2
            }
        }
        Rectangle {
            anchors.fill: parent
            visible: !root.hasPhoto
            color: root.failed ? Appearance.m3colors.m3errorContainer : Appearance.colors.colSecondaryContainer
            Behavior on color { ColorAnimation { duration: 200 } }
            StyledText {
                anchors.centerIn: parent
                visible: root.user.length > 0
                text: root.user.charAt(0).toUpperCase()
                font.pixelSize: root.width * 0.4
                font.weight: Font.DemiBold
                color: root.failed ? Appearance.m3colors.m3onErrorContainer : Appearance.colors.colOnSecondaryContainer
            }
            MaterialSymbol {
                anchors.centerIn: parent
                visible: root.user.length === 0
                text: "person"
                iconSize: root.width * 0.48
                fill: 1
                color: Appearance.colors.colOnSecondaryContainer
            }
        }
        Image {
            id: face
            anchors.fill: parent
            source: "file://" + Quickshell.env("HOME") + "/.face"
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            visible: status === Image.Ready
        }
        Image {
            id: accounts
            anchors.fill: parent
            source: face.status === Image.Ready ? "" : "file:///var/lib/AccountsService/icons/" + root.user
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            visible: status === Image.Ready
        }
    }

    Rectangle {
        width: root.width * 0.41
        height: width
        radius: width / 2
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: -2
        anchors.bottomMargin: -2
        color: root.failed ? Appearance.m3colors.m3errorContainer : Appearance.m3colors.m3primaryContainer
        border.width: 4
        border.color: root.badgeEdge
        Behavior on color { ColorAnimation { duration: 200 } }

        MaterialSymbol {
            id: lockIcon
            anchors.centerIn: parent
            text: (!root.failed && root.open) ? "lock_open" : "lock"
            iconSize: parent.width * 0.5
            fill: 1
            color: root.failed ? Appearance.m3colors.m3onErrorContainer : Appearance.m3colors.m3onPrimaryContainer
            Behavior on color { ColorAnimation { duration: 200 } }
            SequentialAnimation on scale {
                running: root.busy
                loops: Animation.Infinite
                NumberAnimation { to: 0.82; duration: 500; easing.type: Easing.InOutSine }
                NumberAnimation { to: 1.0; duration: 500; easing.type: Easing.InOutSine }
            }
            SequentialAnimation {
                id: wiggleAnim
                NumberAnimation { target: lockIcon; property: "rotation"; to: 16; duration: 80 }
                NumberAnimation { target: lockIcon; property: "rotation"; to: -12; duration: 100 }
                NumberAnimation { target: lockIcon; property: "rotation"; to: 6; duration: 90 }
                NumberAnimation { target: lockIcon; property: "rotation"; to: 0; duration: 300; easing.type: Easing.OutCubic }
            }
        }
    }
}
