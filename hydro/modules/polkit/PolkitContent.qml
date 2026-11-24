import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell

Item {
    id: root
    focus: true

    readonly property var flow: PolkitService.flow
    property bool shown: false
    property bool failed: false
    property bool revealed: false   // show the typed password
    property bool showDetails: false
    property bool busy: !PolkitService.interactionAvailable

    readonly property var spatial: Appearance.animationCurves.expressiveDefaultSpatial
    readonly property int spatialMs: Appearance.animationCurves.expressiveDefaultSpatialDuration
    readonly property string who: root.flow?.selectedIdentity?.displayName ?? ""

    function submit(): void {
        if (!PolkitService.interactionAvailable || field.text.length === 0)
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
            flick.restart();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Appearance.colors.colScrim
        opacity: root.shown ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 280 } }

        Canvas {
            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height) * 0.95
            height: width
            opacity: 0.07
            onPaint: {
                const ctx = getContext("2d");
                ctx.reset();
                ctx.translate(width / 2, height / 2);
                const r = width / 2;
                ctx.beginPath();
                for (let k = 0; k < 6; k++) {
                    const a = (-90 + 60 * k) * Math.PI / 180;
                    const x = r * Math.cos(a), y = r * Math.sin(a);
                    if (k === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
                }
                ctx.closePath();
                ctx.lineWidth = 2;
                ctx.strokeStyle = "white";
                ctx.stroke();
            }
        }
        MouseArea { // clicking outside nudges the card instead of dismissing it
            anchors.fill: parent
            onClicked: shake.restart()
        }
    }

    StyledRectangularShadow {
        target: card
    }

    Rectangle {
        id: card
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.height * 0.04
        width: Math.min(640, root.width - 48)
        height: content.implicitHeight + 28 * 2
        radius: 36
        color: Appearance.m3colors.m3surfaceContainerHigh
        border.width: 1
        border.color: Appearance.colors.colOutlineVariant

        opacity: root.shown ? 1 : 0
        scale: root.shown ? 1 : 0.9
        transform: Translate { id: nudge }
        Behavior on opacity { NumberAnimation { duration: 220 } }
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
            NumberAnimation { target: nudge; property: "x"; to: -16; duration: 55 }
            NumberAnimation { target: nudge; property: "x"; to: 13; duration: 70 }
            NumberAnimation { target: nudge; property: "x"; to: -8; duration: 70 }
            NumberAnimation { target: nudge; property: "x"; to: 4; duration: 60 }
            NumberAnimation { target: nudge; property: "x"; to: 0; duration: 55 }
        }

        RowLayout {
            id: content
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 28
            }
            spacing: 26

            ColumnLayout {
                Layout.alignment: Qt.AlignTop
                Layout.preferredWidth: 112
                spacing: 10

                Item {
                    id: avatarBox
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: 108
                    implicitHeight: 108
                    readonly property string user: Quickshell.env("USER") ?? ""
                    readonly property bool hasPhoto: face.status === Image.Ready || accounts.status === Image.Ready

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
                        id: spinner
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
                            color: root.failed ? Appearance.m3colors.m3errorContainer : Appearance.colors.colSecondaryContainer
                            Behavior on color { ColorAnimation { duration: 200 } }
                            visible: !avatarBox.hasPhoto
                            StyledText {
                                anchors.centerIn: parent
                                visible: avatarBox.user.length > 0
                                text: avatarBox.user.charAt(0).toUpperCase()
                                font.pixelSize: 44
                                font.weight: Font.DemiBold
                                color: root.failed ? Appearance.m3colors.m3onErrorContainer : Appearance.colors.colOnSecondaryContainer
                            }
                            MaterialSymbol {
                                anchors.centerIn: parent
                                visible: avatarBox.user.length === 0
                                text: "person"
                                iconSize: 52
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
                        Image { // AccountsService avatar, used when there's no ~/.face
                            id: accounts
                            anchors.fill: parent
                            source: face.status === Image.Ready ? "" : "file:///var/lib/AccountsService/icons/" + avatarBox.user
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            visible: status === Image.Ready
                        }
                    }

                    Rectangle {
                        id: badge
                        width: 44
                        height: 44
                        radius: 22
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: -2
                        anchors.bottomMargin: -2
                        color: root.failed ? Appearance.m3colors.m3errorContainer : Appearance.m3colors.m3primaryContainer
                        border.width: 4
                        border.color: card.color
                        Behavior on color { ColorAnimation { duration: 200 } }

                        MaterialSymbol {
                            id: lockIcon
                            anchors.centerIn: parent
                            text: (!root.failed && field.text.length > 0) ? "lock_open" : "lock"
                            iconSize: 22
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
                                id: flick
                                NumberAnimation { target: lockIcon; property: "rotation"; to: 16; duration: 80 }
                                NumberAnimation { target: lockIcon; property: "rotation"; to: -12; duration: 100 }
                                NumberAnimation { target: lockIcon; property: "rotation"; to: 6; duration: 90 }
                                NumberAnimation {
                                    target: lockIcon
                                    property: "rotation"
                                    to: 0
                                    duration: 360
                                    easing.type: Easing.BezierSpline
                                    easing.bezierCurve: root.spatial
                                }
                            }
                        }
                    }
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: 112
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    text: avatarBox.user
                    font.pixelSize: Appearance.font.pixelSize.normal
                    font.weight: Font.DemiBold
                    color: Appearance.colors.colOnLayer1
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10

                StyledText {
                    text: Translation.tr("Authentication required")
                    font.family: Appearance.font.family.monospace
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    font.letterSpacing: 2
                    font.capitalization: Font.AllUppercase
                    color: root.failed ? Appearance.m3colors.m3error : Appearance.colors.colPrimary
                }

                StyledText {
                    Layout.fillWidth: true
                    text: PolkitService.cleanMessage.length > 0 ? PolkitService.cleanMessage : Translation.tr("An application needs permission")
                    wrapMode: Text.Wrap
                    maximumLineCount: 4
                    elide: Text.ElideRight
                    font.pixelSize: Appearance.font.pixelSize.huge
                    font.weight: Font.DemiBold
                    color: Appearance.colors.colOnLayer1
                }

                StyledText {
                    visible: root.who.length > 0
                    text: Translation.tr("as %1").arg(root.who)
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.colors.colSubtext
                }

                Rectangle {
                    id: pill
                    Layout.fillWidth: true
                    Layout.topMargin: 8
                    implicitHeight: 56
                    radius: height / 2
                    color: Appearance.colors.colLayer2
                    border.width: field.activeFocus || root.failed ? 2 : 1
                    border.color: root.failed ? Appearance.m3colors.m3error
                                : field.activeFocus ? Appearance.colors.colPrimary
                                : Appearance.colors.colOutlineVariant
                    Behavior on border.color { ColorAnimation { duration: 140 } }

                    RowLayout {
                        anchors {
                            fill: parent
                            leftMargin: 20
                            rightMargin: 8
                        }
                        spacing: 10

                        MaterialSymbol {
                            text: root.failed ? "lock_reset" : "key"
                            iconSize: 22
                            color: root.failed ? Appearance.m3colors.m3error : Appearance.colors.colSubtext
                        }
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            TextInput {
                                id: field
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                enabled: !root.busy
                                echoMode: ((root.flow?.responseVisible ?? false) || root.revealed) ? TextInput.Normal : TextInput.Password
                                passwordCharacter: "●"
                                color: Appearance.colors.colOnLayer1
                                selectionColor: Appearance.colors.colPrimary
                                selectedTextColor: Appearance.colors.colOnPrimary
                                font.family: Appearance.font.family.main
                                font.pixelSize: Appearance.font.pixelSize.normal
                                selectByMouse: true
                                clip: true
                                inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                                onAccepted: root.submit()
                                Keys.onEscapePressed: root.cancel()
                                onTextChanged: if (text.length > 0) root.failed = false
                            }
                            StyledText {
                                anchors.verticalCenter: parent.verticalCenter
                                visible: field.text.length === 0
                                text: root.busy ? Translation.tr("Verifying…") : PolkitService.cleanPrompt
                                font.pixelSize: Appearance.font.pixelSize.normal
                                color: Appearance.colors.colSubtext
                            }
                        }

                        Item {
                            implicitWidth: 36
                            implicitHeight: 36
                            visible: !(root.flow?.responseVisible ?? false)
                            MaterialSymbol {
                                anchors.centerIn: parent
                                text: root.revealed ? "visibility_off" : "visibility"
                                iconSize: 20
                                color: Appearance.colors.colSubtext
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.revealed = !root.revealed;
                                    field.forceActiveFocus();
                                }
                            }
                        }
                        Rectangle {
                            id: go
                            implicitWidth: 42
                            implicitHeight: 42
                            radius: goArea.pressed ? 12 : 21
                            Behavior on radius { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                            readonly property bool ready: !root.busy && field.text.length > 0
                            color: ready ? Appearance.colors.colPrimary : Appearance.colors.colLayer3
                            Behavior on color { ColorAnimation { duration: 140 } }
                            MaterialSymbol {
                                anchors.centerIn: parent
                                text: root.busy ? "progress_activity" : "arrow_forward"
                                iconSize: 22
                                color: go.ready ? Appearance.colors.colOnPrimary : Appearance.colors.colSubtext
                                RotationAnimator on rotation { running: root.busy; from: 0; to: 360; duration: 900; loops: Animation.Infinite }
                            }
                            MouseArea {
                                id: goArea
                                anchors.fill: parent
                                enabled: go.ready
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.submit()
                            }
                        }
                    }
                }

                StyledText {
                    Layout.fillWidth: true
                    visible: text.length > 0
                    wrapMode: Text.Wrap
                    text: root.failed ? Translation.tr("That didn't work. Try again.") : (root.flow?.supplementaryMessage ?? "")
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: (root.failed || (root.flow?.supplementaryIsError ?? false)) ? Appearance.m3colors.m3error : Appearance.colors.colSubtext
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    visible: root.showDetails
                    spacing: 2
                    StyledText {
                        Layout.fillWidth: true
                        wrapMode: Text.WrapAnywhere
                        text: (root.flow?.actionId ?? "") || Translation.tr("No details provided")
                        font.family: Appearance.font.family.monospace
                        font.pixelSize: Appearance.font.pixelSize.smaller
                        color: Appearance.colors.colSubtext
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 2
                    spacing: 6

                    Rectangle { // details toggle
                        implicitHeight: 36
                        implicitWidth: detailsRow.implicitWidth + 24
                        radius: 18
                        color: detailsHover.hovered ? Qt.rgba(1, 1, 1, 0.07) : "transparent"
                        Row {
                            id: detailsRow
                            anchors.centerIn: parent
                            spacing: 6
                            MaterialSymbol {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "expand_more"
                                iconSize: 18
                                rotation: root.showDetails ? 180 : 0
                                color: Appearance.colors.colSubtext
                                Behavior on rotation { NumberAnimation { duration: 160 } }
                            }
                            StyledText {
                                anchors.verticalCenter: parent.verticalCenter
                                text: Translation.tr("Details")
                                font.pixelSize: Appearance.font.pixelSize.small
                                color: Appearance.colors.colSubtext
                            }
                        }
                        HoverHandler { id: detailsHover }
                        TapHandler { onTapped: root.showDetails = !root.showDetails }
                    }

                    Item { Layout.fillWidth: true }

                    Rectangle { // cancel
                        implicitHeight: 40
                        implicitWidth: cancelText.implicitWidth + 36
                        radius: cancelArea.pressed ? 10 : 20
                        Behavior on radius { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                        color: cancelHover.hovered ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
                        border.width: 1
                        border.color: Appearance.colors.colOutlineVariant
                        StyledText {
                            id: cancelText
                            anchors.centerIn: parent
                            text: Translation.tr("Cancel")
                            font.pixelSize: Appearance.font.pixelSize.small
                            font.weight: Font.Medium
                            color: Appearance.colors.colOnLayer1
                        }
                        HoverHandler { id: cancelHover }
                        MouseArea {
                            id: cancelArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.cancel()
                        }
                    }
                }
            }
        }
    }
}
