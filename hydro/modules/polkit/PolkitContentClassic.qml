import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    focus: true

    readonly property var flow: PolkitService.flow
    property bool shown: false
    property bool failed: false
    property bool busy: !PolkitService.interactionAvailable

    readonly property var spatial: Appearance.animationCurves.expressiveDefaultSpatial
    readonly property int spatialMs: Appearance.animationCurves.expressiveDefaultSpatialDuration

    function submit(): void {
        if (!PolkitService.interactionAvailable)
            return;
        failed = false;
        PolkitService.submit(field.text);
        field.text = "";
    }
    function cancel(): void {
        PolkitService.cancel();
    }

    Component.onCompleted: {
        shown = true;
        field.forceActiveFocus();
    }
    Keys.onEscapePressed: cancel()

    Connections {
        target: PolkitService
        function onInteractionAvailableChanged(): void {
            if (PolkitService.interactionAvailable)
                field.forceActiveFocus();
        }
    }
    Connections {
        target: PolkitService.flow
        function onAuthenticationFailed(): void {
            root.failed = true;
            shake.restart();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Appearance.colors.colScrim
        opacity: root.shown ? 1 : 0
        Behavior on opacity {
            NumberAnimation { duration: 250 }
        }
        MouseArea { // clicking outside just nudges the card
            anchors.fill: parent
            onClicked: shake.restart()
        }
    }

    StyledRectangularShadow {
        target: card
    }

    Rectangle {
        id: card

        anchors.centerIn: parent
        width: Math.min(440, root.width - 48)
        height: col.implicitHeight + 28 * 2
        radius: Appearance.rounding.verylarge + 6
        color: Appearance.m3colors.m3surfaceContainerHigh

        opacity: root.shown ? 1 : 0
        scale: root.shown ? 1 : 0.86
        transform: Translate {
            id: nudge
        }
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        Behavior on scale {
            NumberAnimation {
                duration: root.spatialMs
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root.spatial
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: root.spatialMs
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root.spatial
            }
        }

        SequentialAnimation {
            id: shake
            NumberAnimation { target: nudge; property: "x"; to: -14; duration: 55 }
            NumberAnimation { target: nudge; property: "x"; to: 12; duration: 70 }
            NumberAnimation { target: nudge; property: "x"; to: -8; duration: 70 }
            NumberAnimation { target: nudge; property: "x"; to: 4; duration: 60 }
            NumberAnimation { target: nudge; property: "x"; to: 0; duration: 55 }
        }

        ColumnLayout {
            id: col
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 28
            spacing: 14

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 60
                implicitHeight: 60
                radius: root.failed ? 18 : 30
                color: root.failed ? Appearance.m3colors.m3errorContainer : Appearance.m3colors.m3primaryContainer
                Behavior on radius {
                    NumberAnimation {
                        duration: root.spatialMs
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: root.spatial
                    }
                }
                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
                MaterialSymbol {
                    anchors.centerIn: parent
                    text: root.failed ? "lock_reset" : "lock"
                    iconSize: 30
                    fill: 1
                    color: root.failed ? Appearance.m3colors.m3onErrorContainer : Appearance.m3colors.m3onPrimaryContainer
                }
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: Translation.tr("Authentication required")
                font.pixelSize: Appearance.font.pixelSize.larger
                font.weight: Font.DemiBold
                color: Appearance.colors.colOnLayer1
            }

            StyledText {
                Layout.fillWidth: true
                visible: text.length > 0
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                text: PolkitService.cleanMessage
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.colors.colSubtext
            }

            MaterialTextField {
                id: field
                Layout.fillWidth: true
                Layout.topMargin: 6
                placeholderText: root.busy ? Translation.tr("Verifying…") : PolkitService.cleanPrompt
                echoMode: (root.flow?.responseVisible ?? false) ? TextInput.Normal : TextInput.Password
                wrapMode: TextEdit.NoWrap
                enabled: !root.busy
                onAccepted: root.submit()
                Keys.onEscapePressed: root.cancel()
                onTextChanged: if (text.length > 0) root.failed = false
            }

            StyledText {
                id: errorText
                Layout.fillWidth: true
                visible: text.length > 0
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                text: root.failed ? Translation.tr("That didn't work. Try again.") : (root.flow?.supplementaryMessage ?? "")
                font.pixelSize: Appearance.font.pixelSize.small
                color: (root.failed || (root.flow?.supplementaryIsError ?? false)) ? Appearance.m3colors.m3error : Appearance.colors.colSubtext
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 4
                spacing: 8

                Item {
                    Layout.fillWidth: true
                }
                DialogButton {
                    buttonText: Translation.tr("Cancel")
                    onClicked: root.cancel()
                }
                DialogButton {
                    buttonText: Translation.tr("Authenticate")
                    enabled: !root.busy && field.text.length > 0
                    onClicked: root.submit()
                }
            }
        }
    }
}
