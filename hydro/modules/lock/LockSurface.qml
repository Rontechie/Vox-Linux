pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import qs
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.modules.common.panels.lock
import qs.modules.background.clock

MouseArea {
    id: root
    required property LockContext context

    readonly property bool failed: context.showFailure || GlobalStates.screenUnlockFailed
    readonly property bool busy: context.unlockInProgress
    readonly property bool powerPending: context.targetAction !== LockContext.ActionEnum.Unlock
    readonly property bool shapeChars: Config.options.lock.materialShapeChars

    readonly property var lay: Config.options.lock.layout
    function snapV(v) {
        const g = Math.max(1, lay.gridSize);
        return lay.snapToGrid ? Math.round(v / g) * g : v;
    }
    function fxOf(n) { return n.indexOf("left") >= 0 ? 0 : (n.indexOf("right") >= 0 ? 1 : 0.5) }
    function fyOf(n) { return n.indexOf("top") >= 0 ? 0 : (n.indexOf("bottom") >= 0 ? 1 : 0.5) }
    function placeX(name, custom, w) {
        const x = name === "custom" ? snapV(custom) : lay.edgeMargin + fxOf(name) * Math.max(0, width - 2 * lay.edgeMargin - w);
        return Math.max(0, Math.min(x, width - w));
    }
    function placeY(name, custom, h) {
        const y = name === "custom" ? snapV(custom) : lay.edgeMargin + fyOf(name) * Math.max(0, height - 2 * lay.edgeMargin - h);
        return Math.max(0, Math.min(y, height - h));
    }
    readonly property var spatial: Appearance.animationCurves.expressiveDefaultSpatial
    readonly property int spatialMs: Appearance.animationCurves.expressiveDefaultSpatialDuration
    property bool revealed: false
    property bool shown: false

    property bool awake: false
    readonly property bool ui: !Config.options.lock.minimalUntilInput || awake
    function wake(): void {
        awake = true;
        idle.restart();
    }
    Timer {
        id: idle
        interval: 8000
        onTriggered: {
            if (root.context.currentText.length > 0 || root.busy || root.failed || root.powerPending) restart();
            else root.awake = false;
        }
    }

    hoverEnabled: true
    onClicked: { root.wake(); input.forceActiveFocus(); }
    onPositionChanged: root.wake()

    function submit(): void {
        if (!root.busy) root.context.tryUnlock();
    }
    function powerAction(action): void {
        if (Config.options.lock.security.requirePasswordToPower) {
            root.context.targetAction = action;
            input.forceActiveFocus();
        } else if (action === LockContext.ActionEnum.Poweroff) {
            Session.poweroff();
        } else {
            Session.reboot();
        }
    }

    Component.onCompleted: {
        shown = true;
        input.forceActiveFocus();
    }
    onBusyChanged: if (!busy) input.forceActiveFocus()
    onFailedChanged: if (failed) {
        shake.restart();
        avatar.wiggle();
    }
    Connections {
        target: root.context
        function onShouldReFocus(): void { input.forceActiveFocus(); }
    }

    SystemClock {
        id: clock
        precision: Config.options.time.secondPrecision ? SystemClock.Seconds : SystemClock.Minutes
    }

    Item {
        anchors.fill: parent
        clip: true

        Image {
            id: wall
            anchors.fill: parent
            readonly property string wp: Config.options.background.wallpaperPath
            readonly property bool isVideo: /\.(mp4|webm|mkv|avi|mov)$/i.test(wp)
            source: wp.length === 0 ? Quickshell.shellPath("assets/images/default_wallpaper.png")
                  : (isVideo ? Config.options.background.thumbnailPath : wp)
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: false
            sourceSize: Qt.size(Math.max(1, width) * 1, Math.max(1, height) * 1) // decode at screen size, not the file's full size
            scale: Config.options.lock.blur.enable && root.ui ? Config.options.lock.blur.extraZoom : 1
            Behavior on scale { NumberAnimation { duration: 450; easing.type: Easing.OutCubic } }
            layer.enabled: Config.options.lock.blur.enable
            layer.effect: MultiEffect {
                blurEnabled: true
                blurMax: 64
                blur: root.ui ? Math.min(1, Config.options.lock.blur.radius / 100) : 0
                Behavior on blur { NumberAnimation { duration: 450 } }
            }
        }
        Rectangle { // darken, a bit more toward the bottom where the card is
            anchors.fill: parent
            opacity: root.ui ? 1 : 0.18
            Behavior on opacity { NumberAnimation { duration: 450 } }
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.30) }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.62) }
            }
        }
    }

    LockDashboard {
        surface: root
        anchors.fill: parent
        visible: root.lay.mode === "dashboard" && root.width >= 1280
        opacity: root.shown && root.ui ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 480 } }
    }

    ColumnLayout {
        id: clockBlock
        readonly property string spot: root.lay.clock.anchor
        readonly property bool legacy: spot === "default"
        readonly property bool centered: Config.options.lock.centerClock
        readonly property int textAlign: legacy ? (centered ? Qt.AlignHCenter : Qt.AlignLeft)
            : (root.fxOf(spot) === 0 ? Qt.AlignLeft : (root.fxOf(spot) === 1 ? Qt.AlignRight : Qt.AlignHCenter))
        visible: root.lay.clock.enable
        anchors.horizontalCenter: legacy && centered ? parent.horizontalCenter : undefined
        anchors.left: legacy && !centered ? parent.left : undefined
        anchors.leftMargin: 72
        anchors.top: legacy ? parent.top : undefined
        anchors.topMargin: Math.max(56, parent.height * 0.14)
        x: legacy ? 0 : root.placeX(spot, root.lay.clock.x, width)
        y: legacy ? 0 : root.placeY(spot, root.lay.clock.y, height)
        spacing: 6
        opacity: root.shown ? 1 : 0
        transform: Translate { y: root.shown ? 0 : -24 }
        Behavior on opacity { NumberAnimation { duration: 380 } }

        LockClockBlock {
            date: clock.date
            lay: root.lay
            textAlign: clockBlock.textAlign
            screenHeight: root.height
        }
    }

    LockBatteryPill {
        readonly property string spot: root.lay.battery.anchor
        readonly property bool legacy: spot === "default"
        visible: Battery.available && root.lay.battery.enable
        anchors.top: legacy ? parent.top : undefined
        anchors.right: legacy ? parent.right : undefined
        anchors.margins: 28
        x: legacy ? 0 : root.placeX(spot, root.lay.battery.x, width)
        y: legacy ? 0 : root.placeY(spot, root.lay.battery.y, height)
        opacity: root.ui ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }

    StyledRectangularShadow { target: card; opacity: root.ui ? 1 : 0; Behavior on opacity { NumberAnimation { duration: 320 } } }
    Rectangle {
        id: card
        readonly property string spot: root.lay.card.anchor
        readonly property bool legacy: spot === "default"
        anchors.horizontalCenter: legacy ? parent.horizontalCenter : undefined
        anchors.bottom: legacy ? powerRow.top : undefined
        anchors.bottomMargin: 28
        x: legacy ? 0 : root.placeX(spot, root.lay.card.x, width)
        y: legacy ? 0 : root.placeY(spot, root.lay.card.y, height)
        width: Math.min(root.lay.card.width, root.width - 48)
        height: cardContent.implicitHeight + 26 * 2
        radius: 36
        readonly property color base: Appearance.m3colors.m3surfaceContainerHigh
        color: Qt.rgba(base.r, base.g, base.b, 0.88)
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.14)
        opacity: root.shown && root.ui ? 1 : 0
        transform: Translate { id: nudge; y: root.shown && root.ui ? 0 : 40 }
        Behavior on opacity { NumberAnimation { duration: 320 } }
        Behavior on height {
            NumberAnimation { duration: root.spatialMs; easing.type: Easing.BezierSpline; easing.bezierCurve: root.spatial }
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
            id: cardContent
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 26
            }
            spacing: 24

            HydroAvatar {
                id: avatar
                Layout.alignment: Qt.AlignVCenter
                busy: root.busy
                failed: root.failed
                open: root.context.currentText.length > 0
                badgeEdge: card.base
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                StyledText {
                    text: Quickshell.env("USER") ?? ""
                    font.pixelSize: Appearance.font.pixelSize.huge
                    font.weight: Font.DemiBold
                    color: Appearance.colors.colOnLayer1
                }

                Rectangle {
                    id: pill
                    Layout.fillWidth: true
                    implicitHeight: 54
                    radius: height / 2
                    color: Qt.rgba(1, 1, 1, 0.07)
                    border.width: input.activeFocus || root.failed ? 2 : 1
                    border.color: root.failed ? Appearance.m3colors.m3error
                                : input.activeFocus ? Appearance.colors.colPrimary
                                : Qt.rgba(1, 1, 1, 0.22)
                    Behavior on border.color { ColorAnimation { duration: 140 } }

                    RowLayout {
                        anchors {
                            fill: parent
                            leftMargin: 18
                            rightMargin: 7
                        }
                        spacing: 10

                        MaterialSymbol {
                            text: root.failed ? "lock_reset" : "key"
                            iconSize: 22
                            color: root.failed ? Appearance.m3colors.m3error : Appearance.colors.colSubtext
                        }
                        Item {
                            id: field
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            readonly property bool useShapes: root.shapeChars && !root.revealed

                            TextInput {
                                id: input
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                focus: true
                                echoMode: root.revealed ? TextInput.Normal : TextInput.Password
                                passwordCharacter: "●"
                                opacity: field.useShapes ? 0 : 1
                                color: Appearance.colors.colOnLayer1
                                selectionColor: Appearance.colors.colPrimary
                                selectedTextColor: Appearance.colors.colOnPrimary
                                font.family: Appearance.font.family.main
                                font.pixelSize: Appearance.font.pixelSize.normal
                                inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                                enabled: !root.busy
                                clip: true
                                onTextChanged: { root.wake(); if (root.context.currentText !== text) root.context.currentText = text; }
                                onAccepted: root.submit()
                                Keys.onEscapePressed: root.context.reset()
                                Binding { target: input; property: "text"; value: root.context.currentText }
                            }
                            Row {
                                visible: field.useShapes
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 5
                                Repeater {
                                    model: field.useShapes ? root.context.currentText.length : 0
                                    delegate: MaterialShape {
                                        id: ch
                                        required property int index
                                        readonly property var pool: [
                                            MaterialShape.Shape.Cookie9Sided, MaterialShape.Shape.Clover4Leaf,
                                            MaterialShape.Shape.Flower, MaterialShape.Shape.SoftBurst,
                                            MaterialShape.Shape.Pentagon, MaterialShape.Shape.Cookie7Sided
                                        ]
                                        shape: pool[index % pool.length]
                                        implicitSize: 15
                                        color: Appearance.colors.colPrimary
                                        scale: 0.2
                                        Component.onCompleted: scale = 1
                                        Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutBack } }
                                    }
                                }
                                Rectangle { // caret
                                    visible: input.activeFocus && !root.busy
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 2
                                    height: 18
                                    radius: 1
                                    color: Appearance.colors.colPrimary
                                    SequentialAnimation on opacity {
                                        loops: Animation.Infinite
                                        running: input.activeFocus
                                        NumberAnimation { to: 0; duration: 520 }
                                        NumberAnimation { to: 1; duration: 520 }
                                    }
                                }
                            }
                            StyledText {
                                anchors.verticalCenter: parent.verticalCenter
                                visible: root.context.currentText.length === 0
                                text: root.busy ? Translation.tr("Checking…") : Translation.tr("Password")
                                font.pixelSize: Appearance.font.pixelSize.normal
                                color: Appearance.colors.colSubtext
                            }
                        }

                        Item { // reveal
                            implicitWidth: 34
                            implicitHeight: 34
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
                                    input.forceActiveFocus();
                                }
                            }
                        }
                        Rectangle { // unlock
                            id: go
                            implicitWidth: 40
                            implicitHeight: 40
                            radius: goArea.pressed ? 12 : 20
                            Behavior on radius { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                            readonly property bool ready: !root.busy && root.context.currentText.length > 0
                            color: ready ? Appearance.colors.colPrimary : Qt.rgba(1, 1, 1, 0.12)
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

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    visible: statusText.text.length > 0
                    MaterialSymbol {
                        text: root.failed ? "error" : (root.powerPending ? "power_settings_new" : "fingerprint")
                        iconSize: 18
                        color: root.failed ? Appearance.m3colors.m3error : Appearance.colors.colSubtext
                    }
                    StyledText {
                        id: statusText
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                        font.pixelSize: Appearance.font.pixelSize.small
                        color: root.failed ? Appearance.m3colors.m3error : Appearance.colors.colSubtext
                        text: root.failed ? Translation.tr("Wrong password. Try again.")
                            : root.powerPending ? (root.context.targetAction === LockContext.ActionEnum.Poweroff
                                ? Translation.tr("Enter your password to shut down") : Translation.tr("Enter your password to restart"))
                            : root.context.fingerprintsConfigured ? Translation.tr("Touch the fingerprint sensor, or type your password")
                            : ""
                    }
                    Item {
                        visible: root.powerPending
                        implicitWidth: 26
                        implicitHeight: 26
                        MaterialSymbol { anchors.centerIn: parent; text: "close"; iconSize: 18; color: Appearance.colors.colSubtext }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.context.resetTargetAction() }
                    }
                }
            }
        }
    }

    LockPowerRow {
        id: powerRow
        readonly property string spot: root.lay.power.anchor
        readonly property bool legacy: spot === "default"
        visible: root.lay.power.enable
        anchors.horizontalCenter: legacy ? parent.horizontalCenter : undefined
        anchors.bottom: legacy ? parent.bottom : undefined
        anchors.bottomMargin: Math.max(28, parent.height * 0.05)
        x: legacy ? 0 : root.placeX(spot, root.lay.power.x, width)
        y: legacy ? 0 : root.placeY(spot, root.lay.power.y, height)
        spacing: 14
        enabled: root.ui
        opacity: root.shown && root.ui ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 420 } }

        onTriggered: action => {
            if (action === "sleep") Session.suspend();
            else if (action === "reboot") root.powerAction(LockContext.ActionEnum.Reboot);
            else root.powerAction(LockContext.ActionEnum.Poweroff);
        }
    }
}
