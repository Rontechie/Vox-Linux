pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell
import qs
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.modules.common.panels.lock
import qs.modules.desktopWidgets.ui
import "iridium"

MouseArea {
    id: root
    required property LockContext context

    readonly property var cfg: Config.options.lock.iridium
    readonly property bool failed: context.showFailure || GlobalStates.screenUnlockFailed
    readonly property bool busy: context.unlockInProgress
    readonly property bool powerPending: context.targetAction !== LockContext.ActionEnum.Unlock
    readonly property bool horizontal: cfg.horizontal

    readonly property real pwW: Math.max(320, Math.min(520, width * 0.34))
    readonly property real stackH: session.implicitHeight + 14 + password.implicitHeight + 14 + media.collapsedH
    readonly property real gap: 28
    readonly property real clockMax: horizontal
        ? Math.min(height - 140, width - pwW - 120 - 96)
        : Math.min(width - 96, height - stackH - gap - 120)
    readonly property real clockSize: Math.max(150, Math.min(540, clockMax) * cfg.clockScale)

    readonly property real groupH: horizontal ? Math.max(clockSize, stackH) : clockSize + gap + stackH
    readonly property real groupW: horizontal ? clockSize + 56 + clockSize * 0.12 + pwW : Math.max(clockSize, pwW)
    readonly property real clockX: horizontal ? (width - groupW) / 2 : (width - clockSize) / 2
    readonly property real clockY: horizontal ? (height - clockSize) / 2 : (height - groupH) / 2
    readonly property real stackX: horizontal ? clockX + clockSize + 56 + clockSize * 0.12 : (width - pwW) / 2
    readonly property real stackY: horizontal ? (height - stackH) / 2 : clockY + clockSize + gap

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: mouse => {
        stylePopup.shown = false;
        notif.expanded = false;
        password.input.forceActiveFocus();
    }

    function submit(): void {
        if (!root.busy) root.context.tryUnlock();
    }
    function sessionAction(key): void {
        if (key === "sleep") {
            Session.suspend();
            return;
        }
        const action = key === "shutdown" ? LockContext.ActionEnum.Poweroff : LockContext.ActionEnum.Reboot;
        if (Config.options.lock.security.requirePasswordToPower) {
            root.context.targetAction = action;
            password.input.forceActiveFocus();
        } else if (action === LockContext.ActionEnum.Poweroff) {
            Session.poweroff();
        } else {
            Session.reboot();
        }
    }

    Component.onCompleted: password.input.forceActiveFocus()
    onBusyChanged: if (!busy) password.input.forceActiveFocus()
    onFailedChanged: if (failed) password.shake()
    Connections {
        target: root.context
        function onShouldReFocus(): void { password.input.forceActiveFocus(); }
    }
    Binding { target: HwCava; property: "wanted"; value: true; when: true }

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
            layer.enabled: Config.options.lock.blur.enable
            layer.effect: MultiEffect {
                blurEnabled: true
                blurMax: 64
                blur: Math.min(1, Config.options.lock.blur.radius / 100)
            }
        }
        Rectangle { anchors.fill: parent; color: "#4D000000" }
    }

    IrCava {
        active: root.cfg.cavaEnabled
        edge: root.cfg.cavaEdge
    }

    IrClock {
        id: clock
        x: root.clockX
        y: root.clockY
        width: root.clockSize
        height: root.clockSize
        style: root.cfg.clockStyle
        showHands: root.cfg.showHands
        showNums: root.cfg.showNumbers
        use24h: !/ap/i.test(Config.options.time.format)
        fontScale: 1
        Behavior on x { NumberAnimation { duration: 520; easing.type: Easing.OutCubic } }
        Behavior on y { NumberAnimation { duration: 520; easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
        Behavior on height { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton | Qt.LeftButton
            onClicked: mouse => {
                if (mouse.button === Qt.RightButton) {
                    const p = mapToItem(root, mouse.x, mouse.y);
                    stylePopup.openAt(p.x, p.y);
                } else {
                    stylePopup.shown = false;
                }
                notif.expanded = false;
                password.input.forceActiveFocus();
            }
        }
    }

    Item {
        id: stack
        x: root.stackX
        y: root.stackY
        width: root.pwW
        height: root.stackH
        Behavior on x { NumberAnimation { duration: 520; easing.type: Easing.OutCubic } }
        Behavior on y { NumberAnimation { duration: 520; easing.type: Easing.OutCubic } }

        Row {
            id: topRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6
            IrSessionRow {
                id: session
                onTriggered: key => root.sessionAction(key)
            }
            IrNotifPill { id: notif; height: session.height }
        }

        IrPassword {
            id: password
            y: topRow.height + 14
            width: parent.width
            context: root.context
            busy: root.busy
            failed: root.failed
            onSubmit: root.submit()
            onTyped: { stylePopup.shown = false; notif.expanded = false; }
        }

        StyledText { // status line
            anchors.horizontalCenter: parent.horizontalCenter
            y: password.y + password.height + 4
            visible: text.length > 0
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Appearance.font.pixelSize.small
            color: root.failed ? Appearance.m3colors.m3error : Appearance.colors.colSubtext
            text: root.powerPending ? (root.context.targetAction === LockContext.ActionEnum.Poweroff
                    ? Translation.tr("Enter your password to shut down") : Translation.tr("Enter your password to restart"))
                : root.context.fingerprintsConfigured ? Translation.tr("Touch the fingerprint sensor, or type your password")
                : ""
        }

        IrMedia {
            id: media
            x: (parent.width - width) / 2
            y: password.y + password.height + 14 + (root.context.fingerprintsConfigured || root.powerPending ? 22 : 0)
            collapsedW: Math.min(parent.width * 0.82, 280)
            expandedW: Math.min(root.width - 40, parent.width + 80)
        }
    }

    IrStylePopup {
        id: stylePopup
        z: 30
        onInteracted: password.input.forceActiveFocus()
    }
}
