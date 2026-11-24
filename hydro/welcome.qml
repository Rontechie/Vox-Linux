
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

ApplicationWindow {
    id: root

    property int step: 0
    readonly property int lastStep: 5
    readonly property var stepNames: ["", Translation.tr("Network"), Translation.tr("Wallpaper & colors"), Translation.tr("Look"), Translation.tr("Shortcuts"), ""]

    visible: true
    visibility: Window.FullScreen
    title: "Welcome to Vox"
    onClosing: Qt.quit()
    minimumWidth: 820
    minimumHeight: 580
    width: 980
    height: 680
    color: root.intro ? "#000000" : Appearance.m3colors.m3background

    Component.onCompleted: {
        MaterialThemeLoader.reapplyTheme()
        Config.readWriteDelay = 0
        KeyringStorage.fetchKeyringData()
    }

    readonly property url logoUrl: "file://" + Directories.assetsPath + "/images/hydro-logo.svg"
    property bool intro: true
    function go(i) { step = Math.max(0, Math.min(lastStep, i)) }
    function openSettings() { Quickshell.execDetached(["qs", "-p", Quickshell.shellPath("nexus.qml")]) }
    function switchwall(args) { Quickshell.execDetached(["bash", Directories.wallpaperSwitchScriptPath].concat(args ?? [])) }

    Shortcut { sequence: "Right"; enabled: root.step < root.lastStep; onActivated: root.go(root.step + 1) }
    Shortcut { sequence: "Left";  enabled: root.step > 0; onActivated: root.go(root.step - 1) }
    Shortcut { sequence: "Escape"; onActivated: root.close() }

    readonly property var spatial: Appearance.animationCurves.expressiveDefaultSpatial

    component WButton: Item {
        id: btn
        property string label
        property string icon: ""
        property string kind: "tonal"   // filled | tonal | text | outline
        property bool toggled: false
        property bool busy: false
        signal clicked()
        implicitHeight: 48
        implicitWidth: bRow.implicitWidth + 44
        opacity: enabled ? 1 : 0.4
        scale: bArea.pressed ? 0.93 : (bArea.containsMouse ? 1.04 : 1)
        Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.OutBack } }
        readonly property bool strong: kind === "filled" || toggled
        Rectangle {
            anchors.fill: parent
            radius: bArea.pressed ? 12 : (btn.toggled ? 16 : height / 2)
            color: btn.strong ? Appearance.colors.colPrimary
                 : btn.kind === "tonal" ? (bArea.containsMouse ? Appearance.colors.colSecondaryContainerHover : Appearance.colors.colSecondaryContainer)
                 : (bArea.containsMouse ? Appearance.colors.colLayer1 : "transparent")
            border.width: btn.kind === "outline" && !btn.strong ? 1 : 0
            border.color: Appearance.colors.colOutlineVariant
            Behavior on radius { NumberAnimation { duration: 300; easing.type: Easing.BezierSpline; easing.bezierCurve: Appearance.animationCurves.expressiveFastSpatial } }
            Behavior on color { ColorAnimation { duration: 140 } }
        }
        Row {
            id: bRow
            anchors.centerIn: parent
            spacing: 8
            MaterialSymbol {
                visible: btn.icon.length > 0 || btn.busy
                anchors.verticalCenter: parent.verticalCenter
                text: btn.busy ? "progress_activity" : btn.icon
                iconSize: 20
                color: btn.strong ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSecondaryContainer
                RotationAnimator on rotation { running: btn.busy; from: 0; to: 360; duration: 900; loops: Animation.Infinite }
            }
            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                text: btn.label
                font.pixelSize: Appearance.font.pixelSize.normal
                font.weight: Font.Medium
                color: btn.strong ? Appearance.colors.colOnPrimary : (btn.kind === "tonal" ? Appearance.colors.colOnSecondaryContainer : Appearance.colors.colOnLayer0)
            }
        }
        MouseArea { id: bArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: btn.clicked() }
    }

    component DesktopPreview: Item {
        id: dp
        implicitWidth: 420
        implicitHeight: 230
        readonly property bool barBottom: Config.options.bar.bottom
        readonly property int cs: Config.options.bar.cornerStyle
        readonly property bool floating: cs === 1
        readonly property string wp: Config.options.background.wallpaperPath
        StyledImage {
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: dp.wp.length > 0 ? dp.wp : "file://" + Directories.assetsPath + "/images/default_wallpaper.png"
            cache: false
            layer.enabled: true
            layer.effect: OpacityMask { maskSource: Rectangle { width: dp.width; height: dp.height; radius: 24 } }
        }
        Rectangle {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: dp.barBottom ? -8 : 8
            Behavior on anchors.verticalCenterOffset { NumberAnimation { duration: 500; easing.type: Easing.BezierSpline; easing.bezierCurve: root.spatial } }
            width: parent.width * 0.5; height: parent.height * 0.5
            radius: 14
            color: Appearance.colors.colLayer0
            opacity: 0.92
            Column {
                anchors { left: parent.left; top: parent.top; margins: 14 }
                spacing: 7
                Rectangle { width: 70; height: 8; radius: 4; color: Appearance.colors.colPrimary }
                Rectangle { width: 110; height: 6; radius: 3; color: Appearance.colors.colOutlineVariant }
                Rectangle { width: 90; height: 6; radius: 3; color: Appearance.colors.colOutlineVariant }
            }
        }
        Rectangle {
            id: pbar
            height: 24
            x: dp.floating ? 16 : 0
            width: dp.width - (dp.floating ? 32 : 0)
            y: dp.barBottom ? dp.height - height - (dp.floating ? 12 : 0) : (dp.floating ? 12 : 0)
            radius: dp.floating ? 12 : (dp.cs === 0 ? 6 : 0)
            color: Appearance.colors.colLayer0
            opacity: Config.options.appearance.transparency.enable ? 0.72 : 1
            Behavior on x { NumberAnimation { duration: 500; easing.type: Easing.BezierSpline; easing.bezierCurve: root.spatial } }
            Behavior on width { NumberAnimation { duration: 500; easing.type: Easing.BezierSpline; easing.bezierCurve: root.spatial } }
            Behavior on y { NumberAnimation { duration: 500; easing.type: Easing.BezierSpline; easing.bezierCurve: root.spatial } }
            Behavior on radius { NumberAnimation { duration: 400 } }
            Behavior on opacity { NumberAnimation { duration: 300 } }
            Row { anchors { left: parent.left; leftMargin: 12; verticalCenter: parent.verticalCenter } spacing: 5
                Repeater { model: 3; Rectangle { required property int index; width: index === 0 ? 16 : 9; height: 9; radius: 4.5; color: index === 0 ? Appearance.colors.colPrimary : Appearance.colors.colOutlineVariant } } }
            Rectangle { anchors { right: parent.right; rightMargin: 12; verticalCenter: parent.verticalCenter } width: 26; height: 9; radius: 4.5; color: Appearance.colors.colOutlineVariant }
        }
    }

    component SummaryPill: Rectangle {
        property string icon
        property string text
        implicitHeight: 38
        implicitWidth: sp.implicitWidth + 28
        radius: 19
        color: Appearance.colors.colSecondaryContainer
        Row {
            id: sp
            anchors.centerIn: parent
            spacing: 8
            MaterialSymbol { anchors.verticalCenter: parent.verticalCenter; text: parent.parent.icon; iconSize: 18; color: Appearance.colors.colOnSecondaryContainer }
            StyledText { anchors.verticalCenter: parent.verticalCenter; text: parent.parent.text; font.pixelSize: Appearance.font.pixelSize.small; color: Appearance.colors.colOnSecondaryContainer }
        }
    }

    component Caption: StyledText {
        color: Appearance.colors.colSubtext
        font.pixelSize: Appearance.font.pixelSize.small
        font.weight: Font.Medium
        Layout.topMargin: 8
    }

    component Heading: ColumnLayout {
        property string title
        property string sub
        property string icon
        property var shape: MaterialShape.Shape.Cookie9Sided
        spacing: 6
        RowLayout {
            spacing: 14
            MaterialShapeWrappedMaterialSymbol {
                shape: parent.parent.shape
                text: parent.parent.icon
                iconSize: 26
                padding: 13
                color: Appearance.colors.colPrimaryContainer
                colSymbol: Appearance.colors.colOnPrimaryContainer
            }
            StyledText {
                text: parent.parent.title
                color: Appearance.colors.colOnLayer0
                font.family: Appearance.font.family.expressive
                font.pixelSize: 38
                font.weight: Font.DemiBold
            }
        }
        StyledText {
            Layout.fillWidth: true
            Layout.topMargin: 4
            wrapMode: Text.WordWrap
            text: parent.sub
            color: Appearance.colors.colSubtext
            font.pixelSize: Appearance.font.pixelSize.larger
        }
    }

    component WPage: Item {
        id: pg
        property int idx
        default property alias contentData: col.data
        width: stage.width
        height: stage.height
        x: (idx - root.step) * width * 0.5
        opacity: idx === root.step ? 1 : 0
        visible: opacity > 0.01
        Behavior on x { NumberAnimation { duration: 520; easing.type: Easing.BezierSpline; easing.bezierCurve: root.spatial } }
        Behavior on opacity { NumberAnimation { duration: 260 } }
        ColumnLayout {
            id: col
            width: Math.min(760, parent.width - 80)
            anchors.horizontalCenter: parent.horizontalCenter
            y: Math.max(0, (parent.height - implicitHeight) / 2 - 20)
            spacing: 14
        }
    }


    component WFull: Item {
        id: pf
        property int idx
        width: stage.width
        height: stage.height
        x: (idx - root.step) * width * 0.5
        opacity: idx === root.step ? 1 : 0
        visible: opacity > 0.01
        Behavior on x { NumberAnimation { duration: 520; easing.type: Easing.BezierSpline; easing.bezierCurve: root.spatial } }
        Behavior on opacity { NumberAnimation { duration: 260 } }
    }

    component WLink: Item {
        id: lk
        property string icon
        property string label
        signal clicked()
        implicitWidth: lkRow.implicitWidth
        implicitHeight: 32
        Row {
            id: lkRow
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12
            MaterialSymbol {
                anchors.verticalCenter: parent.verticalCenter
                text: lk.icon
                iconSize: 20
                color: lkArea.containsMouse ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer0
                Behavior on color { ColorAnimation { duration: 140 } }
            }
            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                text: lk.label
                font.pixelSize: Appearance.font.pixelSize.normal
                color: lkArea.containsMouse ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer0
                Behavior on color { ColorAnimation { duration: 140 } }
            }
        }
        MouseArea { id: lkArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: lk.clicked() }
    }

    readonly property string langName: {
        const code = (Translation.languageCode ?? "en_US");
        const loc = Qt.locale(code);
        const l = loc.nativeLanguageName;
        const c = loc.nativeCountryName;
        const cap = l.length > 0 ? l.charAt(0).toUpperCase() + l.slice(1) : code;
        return c.length > 0 ? cap + " (" + c + ")" : cap;
    }
    readonly property string regionCode: {
        const parts = (Translation.languageCode ?? "en_US").split(/[_-]/);
        return (parts.length > 1 ? parts[1] : parts[0]).toUpperCase();
    }

    Process {
        id: randomWallProc
        property string scriptPath
        command: ["bash", FileUtils.trimFileProtocol(randomWallProc.scriptPath)]
    }

    Item {
        id: backdrop
        anchors.fill: parent
        z: -1
        readonly property string wp: Config.options.background.wallpaperPath
        StyledImage {
            id: backdropImg
            anchors.fill: parent
            visible: false
            fillMode: Image.PreserveAspectCrop
            source: backdrop.wp.length > 0 ? backdrop.wp : "file://" + Directories.assetsPath + "/images/default_wallpaper.png"
            sourceSize: Qt.size(1280, 720)
            cache: false
        }
        MultiEffect {
            anchors.fill: parent
            source: backdropImg
            blurEnabled: true
            blur: 1
            blurMax: 64
            saturation: 0.1
            brightness: 0.06
        }
        Rectangle {
            anchors.fill: parent
            color: Appearance.m3colors.m3background
            opacity: 0.22
        }
    }

    StyledText {
        anchors { top: parent.top; right: parent.right; topMargin: 14; rightMargin: 18 }
        z: 5
        text: "Hydro  ·  " + SystemInfo.distroName
        font.pixelSize: Appearance.font.pixelSize.smaller
        color: Appearance.colors.colOnLayer0
        opacity: 0.6
    }

    Rectangle {
        id: statusPill
        z: 5
        anchors { bottom: parent.bottom; right: parent.right; bottomMargin: 14; rightMargin: 16 }
        implicitHeight: 38
        implicitWidth: pillRow.implicitWidth + 24
        radius: height / 2
        color: Appearance.colors.colLayer0
        border.width: 1
        border.color: Appearance.colors.colLayer0Border
        Row {
            id: pillRow
            anchors.centerIn: parent
            spacing: 12
            StyledText { anchors.verticalCenter: parent.verticalCenter; text: Qt.locale().toString(DateTime.clock.date, "MMM d"); font.pixelSize: Appearance.font.pixelSize.small; color: Appearance.colors.colOnLayer0 }
            StyledText { anchors.verticalCenter: parent.verticalCenter; text: DateTime.time; font.pixelSize: Appearance.font.pixelSize.small; font.weight: Font.Medium; color: Appearance.colors.colOnLayer0 }
            StyledText { anchors.verticalCenter: parent.verticalCenter; text: root.regionCode; font.pixelSize: Appearance.font.pixelSize.small; color: Appearance.colors.colSubtext }
            MaterialSymbol { anchors.verticalCenter: parent.verticalCenter; text: Network.materialSymbol; iconSize: 18; color: Appearance.colors.colOnLayer0 }
            Row {
                visible: Battery.available
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                MaterialSymbol { anchors.verticalCenter: parent.verticalCenter; text: Battery.isCharging ? "battery_charging_full" : "battery_full"; iconSize: 18; color: Battery.isLow ? Appearance.m3colors.m3error : Appearance.colors.colOnLayer0 }
                StyledText { anchors.verticalCenter: parent.verticalCenter; text: Math.round(Battery.percentage * 100) + "%"; font.pixelSize: Appearance.font.pixelSize.smaller; color: Appearance.colors.colSubtext }
            }
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: tagText.implicitWidth + 16
                implicitHeight: 22
                radius: 11
                color: Appearance.colors.colPrimaryContainer
                StyledText { id: tagText; anchors.centerIn: parent; text: "Hydro"; font.pixelSize: Appearance.font.pixelSize.smaller; font.weight: Font.Medium; color: Appearance.colors.colOnPrimaryContainer }
            }
        }
    }

    StyledRectangularShadow { target: card; visible: !root.intro }
    Rectangle {
        id: card
        readonly property bool compact: root.step === 0 || root.step === root.lastStep
        anchors.centerIn: parent
        width: compact ? Math.min(parent.width - 120, Math.max(880, parent.width * 0.78), 1240)
                       : Math.min(parent.width - 80, 1320)
        height: compact ? Math.min(parent.height - 110, Math.max(560, parent.height * 0.76), 780)
                        : Math.min(parent.height - 60, 980)
        radius: 32
        color: Appearance.colors.colLayer0
        border.width: 1
        border.color: Appearance.colors.colLayer0Border
        opacity: root.intro ? 0 : 1
        Behavior on width { NumberAnimation { duration: 520; easing.type: Easing.BezierSpline; easing.bezierCurve: root.spatial } }
        Behavior on height { NumberAnimation { duration: 520; easing.type: Easing.BezierSpline; easing.bezierCurve: root.spatial } }
        Behavior on opacity { NumberAnimation { duration: 500 } }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            implicitHeight: 76
            opacity: root.step > 0 && root.step < root.lastStep ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 250 } }

            RowLayout {
                anchors { fill: parent; leftMargin: 40; rightMargin: 40 }
                spacing: 16
                StyledText {
                    text: Translation.tr("Quickstart")
                    color: Appearance.colors.colSubtext
                    font.pixelSize: Appearance.font.pixelSize.normal
                    font.weight: Font.Medium
                }
                Row {
                    spacing: 10
                    Repeater {
                        model: [{ i: "wifi" }, { i: "wallpaper" }, { i: "palette" }, { i: "keyboard" }]
                        Item {
                            id: chip
                            required property int index
                            required property var modelData
                            readonly property bool active: root.step === index + 1
                            readonly property bool done: root.step > index + 1
                            width: 44; height: 44
                            scale: active ? 1.18 : (chipArea.containsMouse ? 1.08 : 1)
                            Behavior on scale { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
                            MaterialShape {
                                anchors.centerIn: parent
                                implicitSize: 40
                                shape: chip.active ? MaterialShape.Shape.Cookie9Sided : (chip.done ? MaterialShape.Shape.Circle : MaterialShape.Shape.Square)
                                color: chip.active ? Appearance.colors.colPrimary : (chip.done ? Appearance.colors.colPrimaryContainer : Appearance.colors.colLayer1)
                                RotationAnimator on rotation { running: chip.active; from: 0; to: 360; duration: 12000; loops: Animation.Infinite }
                            }
                            MaterialSymbol {
                                anchors.centerIn: parent
                                text: chip.done ? "check" : chip.modelData.i
                                iconSize: 20
                                color: chip.active ? Appearance.colors.colOnPrimary : (chip.done ? Appearance.colors.colOnPrimaryContainer : Appearance.colors.colSubtext)
                            }
                            MouseArea { id: chipArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.go(chip.index + 1) }
                        }
                    }
                }
                Item { Layout.fillWidth: true }
                WButton { kind: "text"; label: Translation.tr("Skip setup"); onClicked: root.close() }
            }
        }

        Item {
            id: stage
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            HoverHandler { id: stageHover }

            WFull {
                id: welcomePage
                idx: 0

                ColumnLayout {
                    anchors {
                        left: parent.left
                        leftMargin: Math.max(40, parent.width * 0.06)
                        top: parent.top
                        topMargin: Math.max(36, parent.height * 0.12)
                    }
                    width: parent.width * 0.46
                    spacing: 10

                    Image {
                        Layout.bottomMargin: 8
                        source: root.logoUrl
                        sourceSize: Qt.size(112, 112)
                        Layout.preferredWidth: 56
                        Layout.preferredHeight: 56
                        smooth: true
                    }
                    StyledText {
                        Layout.fillWidth: true
                        text: Translation.tr("Welcome to Vox")
                        wrapMode: Text.WordWrap
                        color: Appearance.colors.colOnLayer0
                        font.family: Appearance.font.family.expressive
                        font.pixelSize: Math.max(34, Math.min(58, welcomePage.width / 17))
                        font.weight: Font.Medium
                    }
                    StyledText {
                        Layout.fillWidth: true
                        text: Translation.tr("Fast. Fluid. Yours.")
                        color: Appearance.colors.colOnLayer0
                        font.pixelSize: Appearance.font.pixelSize.huge
                    }
                    Item { Layout.preferredHeight: Math.max(18, welcomePage.height * 0.07) }
                    WLink { icon: "language"; label: root.langName; onClicked: root.openSettings() }
                    WLink { icon: "accessibility_new"; label: Translation.tr("Accessibility"); onClicked: root.openSettings() }
                }

                Item {
                    id: art
                    anchors {
                        right: parent.right
                        rightMargin: Math.max(24, parent.width * 0.04)
                        top: parent.top
                        topMargin: parent.height * 0.1
                        bottom: parent.bottom
                        bottomMargin: parent.height * 0.2
                    }
                    width: parent.width * 0.46
                    readonly property real px: (stageHover.point.position.x - stage.width / 2) / stage.width
                    readonly property real py: (stageHover.point.position.y - stage.height / 2) / stage.height
                    readonly property real unit: Math.min(width, height)

                    MaterialShape {
                        id: artBig
                        anchors.centerIn: parent
                        implicitSize: art.unit * 0.95
                        shape: MaterialShape.Shape.Cookie12Sided
                        color: Appearance.colors.colPrimaryContainer
                        opacity: 0.55
                        RotationAnimator on rotation { from: 0; to: 360; duration: 120000; loops: Animation.Infinite; running: !root.intro && root.step === 0 }
                    }
                    MaterialShape {
                        implicitSize: art.unit * 0.34
                        shape: MaterialShape.Shape.Sunny
                        color: Appearance.colors.colTertiaryContainer
                        x: art.width * 0.78 + art.px * -26
                        y: art.height * 0.02 + art.py * -18
                        Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                        Behavior on y { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                        RotationAnimator on rotation { from: 0; to: 360; duration: 40000; loops: Animation.Infinite; running: !root.intro && root.step === 0 }
                    }
                    MaterialShape {
                        implicitSize: art.unit * 0.3
                        shape: MaterialShape.Shape.Flower
                        color: Appearance.colors.colSecondaryContainer
                        x: art.width * 0.02 + art.px * 22
                        y: art.height * 0.74 + art.py * 18
                        Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                        Behavior on y { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                        RotationAnimator on rotation { from: 360; to: 0; duration: 50000; loops: Animation.Infinite; running: !root.intro && root.step === 0 }
                    }
                    DesktopPreview {
                        id: artPreview
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: art.px * 14
                        scale: Math.min(art.width / 420, art.height / 230) * 0.9
                        SequentialAnimation on anchors.verticalCenterOffset {
                            loops: Animation.Infinite
                            running: !root.intro && root.step === 0
                            NumberAnimation { from: -6; to: 6; duration: 2600; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 6; to: -6; duration: 2600; easing.type: Easing.InOutSine }
                        }
                    }
                    Rectangle { width: 16; height: 16; radius: 8; color: Appearance.colors.colPrimary; x: art.width * 0.5; y: art.height * -0.04 }
                    Rectangle { width: 22; height: 22; radius: 11; color: "transparent"; border.width: 3; border.color: Appearance.colors.colOnLayer0; opacity: 0.55; x: art.width * 0.28; y: art.height * 0.08 }
                    Rectangle { width: 12; height: 12; radius: 6; color: Appearance.colors.colTertiary; x: art.width * 0.93; y: art.height * 0.62 }
                    Rectangle { width: 10; height: 10; radius: 5; color: Appearance.colors.colSecondary; x: art.width * 0.15; y: art.height * 0.5 }
                }

                RowLayout {
                    anchors {
                        left: parent.left
                        leftMargin: Math.max(40, parent.width * 0.06)
                        bottom: parent.bottom
                        bottomMargin: Math.max(28, parent.height * 0.08)
                    }
                    spacing: 10
                    WButton { kind: "filled"; label: Translation.tr("Get started"); onClicked: root.go(1) }
                    WButton { kind: "text"; label: Translation.tr("Maybe later"); onClicked: root.close() }
                }
            }

            WPage {
                id: netPage
                idx: 1
                Component.onCompleted: Network.update()
                property bool shown: root.step === 1
                onShownChanged: if (shown && Network.wifiEnabled) Network.rescanWifi()

                Heading {
                    Layout.fillWidth: true
                    icon: "wifi"
                    shape: MaterialShape.Shape.Flower
                    title: Translation.tr("Connect to a network")
                    sub: Network.ethernet ? Translation.tr("You are online through Ethernet. Wi-Fi is optional.")
                       : Translation.tr("Pick a Wi-Fi network. You can skip this and connect later from the bar.")
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 6
                    spacing: 10
                    StyledText {
                        Layout.fillWidth: true
                        text: Network.active ? Translation.tr("Connected to %1").arg(Network.active.ssid)
                            : Network.wifiEnabled ? Translation.tr("Available networks") : Translation.tr("Wi-Fi is off")
                        color: Network.active ? Appearance.colors.colPrimary : Appearance.colors.colSubtext
                        font.pixelSize: Appearance.font.pixelSize.normal
                        font.weight: Font.Medium
                    }
                    WButton {
                        kind: "outline"
                        icon: "refresh"
                        label: Translation.tr("Rescan")
                        enabled: Network.wifiEnabled && !Network.wifiScanning
                        busy: Network.wifiScanning
                        onClicked: Network.rescanWifi()
                    }
                    WButton {
                        kind: Network.wifiEnabled ? "filled" : "tonal"
                        icon: Network.wifiEnabled ? "wifi" : "wifi_off"
                        label: Network.wifiEnabled ? Translation.tr("On") : Translation.tr("Off")
                        onClicked: Network.toggleWifi()
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(120, Math.min(300, stage.height - 330))
                    radius: 24
                    color: Appearance.colors.colLayer1
                    clip: true

                    StyledText {
                        anchors.centerIn: parent
                        visible: !Network.wifiEnabled || Network.friendlyWifiNetworks.length === 0
                        text: !Network.wifiEnabled ? Translation.tr("Turn Wi-Fi on to see networks")
                            : Network.wifiScanning ? Translation.tr("Looking for networks…") : Translation.tr("No networks found")
                        color: Appearance.colors.colSubtext
                        font.pixelSize: Appearance.font.pixelSize.normal
                    }

                    ListView {
                        id: netList
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        model: Network.wifiEnabled ? Network.friendlyWifiNetworks : []

                        delegate: Item {
                            id: ap
                            required property var modelData
                            readonly property bool connecting: Network.wifiConnecting && Network.wifiConnectTarget === modelData
                            width: netList.width
                            height: apCol.implicitHeight

                            Column {
                                id: apCol
                                width: parent.width
                                spacing: 6

                                Rectangle {
                                    width: parent.width
                                    height: 52
                                    radius: 18
                                    color: ap.modelData.active ? Appearance.colors.colPrimaryContainer
                                         : apArea.containsMouse ? Appearance.colors.colLayer2Hover : "transparent"
                                    Behavior on color { ColorAnimation { duration: 140 } }
                                    RowLayout {
                                        anchors { fill: parent; leftMargin: 16; rightMargin: 16 }
                                        spacing: 14
                                        MaterialSymbol {
                                            text: ap.modelData.strength > 75 ? "signal_wifi_4_bar" : ap.modelData.strength > 50 ? "network_wifi_3_bar" : ap.modelData.strength > 25 ? "network_wifi_2_bar" : "network_wifi_1_bar"
                                            iconSize: 22
                                            color: ap.modelData.active ? Appearance.colors.colOnPrimaryContainer : Appearance.colors.colOnLayer1
                                        }
                                        StyledText {
                                            Layout.fillWidth: true
                                            text: ap.modelData.ssid
                                            elide: Text.ElideRight
                                            font.pixelSize: Appearance.font.pixelSize.normal
                                            font.weight: ap.modelData.active ? Font.DemiBold : Font.Normal
                                            color: ap.modelData.active ? Appearance.colors.colOnPrimaryContainer : Appearance.colors.colOnLayer1
                                        }
                                        MaterialSymbol {
                                            visible: ap.connecting || ap.modelData.active || ap.modelData.isSecure
                                            text: ap.connecting ? "progress_activity" : ap.modelData.active ? "check" : "lock"
                                            iconSize: 18
                                            color: ap.modelData.active ? Appearance.colors.colOnPrimaryContainer : Appearance.colors.colSubtext
                                            RotationAnimator on rotation { running: ap.connecting; from: 0; to: 360; duration: 900; loops: Animation.Infinite }
                                        }
                                    }
                                    MouseArea {
                                        id: apArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: ap.modelData.active ? Network.disconnectWifiNetwork() : Network.connectToWifiNetwork(ap.modelData)
                                    }
                                }

                                Rectangle {
                                    visible: ap.modelData.askingPassword
                                    width: parent.width
                                    height: 48
                                    radius: 24
                                    color: Appearance.colors.colLayer0
                                    border.width: pwIn.activeFocus ? 2 : 1
                                    border.color: pwIn.activeFocus ? Appearance.colors.colPrimary : Appearance.colors.colOutlineVariant
                                    TextInput {
                                        id: pwIn
                                        anchors { fill: parent; leftMargin: 20; rightMargin: 64 }
                                        verticalAlignment: TextInput.AlignVCenter
                                        echoMode: TextInput.Password
                                        passwordCharacter: "•"
                                        selectByMouse: true
                                        clip: true
                                        color: Appearance.colors.colOnLayer0
                                        font.pixelSize: Appearance.font.pixelSize.normal
                                        onVisibleChanged: if (visible) forceActiveFocus()
                                        onAccepted: if (text.length > 0) Network.changePassword(ap.modelData, text)
                                        StyledText {
                                            visible: pwIn.text.length === 0
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: Translation.tr("Password for %1").arg(ap.modelData.ssid)
                                            color: Appearance.colors.colSubtext
                                            font.pixelSize: Appearance.font.pixelSize.normal
                                        }
                                    }
                                    Rectangle {
                                        anchors { right: parent.right; rightMargin: 6; verticalCenter: parent.verticalCenter }
                                        width: 40; height: 36; radius: 18
                                        color: Appearance.colors.colPrimary
                                        MaterialSymbol { anchors.centerIn: parent; text: "arrow_forward"; iconSize: 20; color: Appearance.colors.colOnPrimary }
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: if (pwIn.text.length > 0) Network.changePassword(ap.modelData, pwIn.text)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            WPage {
                idx: 2
                Heading { Layout.fillWidth: true; icon: "wallpaper"; shape: MaterialShape.Shape.Sunny; title: Translation.tr("Wallpaper & colors"); sub: Translation.tr("Colors across the whole shell follow your wallpaper.") }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 8
                    spacing: 28

                    Item {
                        id: prev
                        Layout.alignment: Qt.AlignTop
                        implicitWidth: 320; implicitHeight: 200
                        readonly property string path: Config.options.background.wallpaperPath
                        StyledImage {
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            source: prev.path.length > 0 ? prev.path : Qt.resolvedUrl(Directories.assetsPath + "/images/default_wallpaper.png")
                            cache: false
                            layer.enabled: true
                            layer.effect: OpacityMask { maskSource: Rectangle { width: prev.width; height: prev.height; radius: 32 } }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        spacing: 8
                        Caption { text: Translation.tr("Choose a wallpaper"); Layout.topMargin: 0 }
                        Flow {
                            Layout.fillWidth: true
                            spacing: 8
                            WButton { kind: "filled"; icon: "folder_open"; label: Translation.tr("Choose file"); onClicked: root.switchwall([]) }
                            WButton {
                                visible: Config.options.policies.weeb === 1
                                enabled: !randomWallProc.running
                                busy: randomWallProc.running && randomWallProc.scriptPath.indexOf("konachan") >= 0
                                icon: "casino"; label: "Konachan"
                                onClicked: { randomWallProc.scriptPath = `${Directories.scriptPath}/colors/random/random_konachan_wall.sh`; randomWallProc.running = true }
                            }
                            WButton {
                                visible: Config.options.policies.weeb === 1
                                enabled: !randomWallProc.running
                                busy: randomWallProc.running && randomWallProc.scriptPath.indexOf("osu") >= 0
                                icon: "casino"; label: "osu!"
                                onClicked: { randomWallProc.scriptPath = `${Directories.scriptPath}/colors/random/random_osu_wall.sh`; randomWallProc.running = true }
                            }
                        }
                        Caption { text: Translation.tr("Mode") }
                        Flow {
                            Layout.fillWidth: true
                            spacing: 8
                            WButton { icon: "light_mode"; label: Translation.tr("Light"); toggled: !Appearance.m3colors.darkmode; onClicked: { root.switchwall(["--mode", "light", "--noswitch"]); } }
                            WButton { icon: "dark_mode"; label: Translation.tr("Dark"); toggled: Appearance.m3colors.darkmode; onClicked: { root.switchwall(["--mode", "dark", "--noswitch"]); } }
                        }
                    }
                }

                Caption { text: Translation.tr("Color style") }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Repeater {
                        model: [
                            { value: "auto", name: "Auto" }, { value: "scheme-tonal-spot", name: "Tonal Spot" },
                            { value: "scheme-expressive", name: "Expressive" }, { value: "scheme-fidelity", name: "Fidelity" },
                            { value: "scheme-fruit-salad", name: "Fruit Salad" }, { value: "scheme-rainbow", name: "Rainbow" },
                            { value: "scheme-neutral", name: "Neutral" }, { value: "scheme-monochrome", name: "Monochrome" }
                        ]
                        WButton {
                            required property var modelData
                            label: modelData.name
                            toggled: Config.options.appearance.palette.type === modelData.value
                            onClicked: {
                                Config.options.appearance.palette.type = modelData.value;
                                root.switchwall(["--noswitch"]);
                            }
                        }
                    }
                }
            }

            WPage {
                idx: 3
                Heading { Layout.fillWidth: true; icon: "palette"; shape: MaterialShape.Shape.Flower; title: Translation.tr("Look"); sub: Translation.tr("Where the bar lives and how it feels. Try them, you'll see the change right away.") }
                DesktopPreview { Layout.alignment: Qt.AlignHCenter; Layout.topMargin: 6 }

                Caption { text: Translation.tr("Bar position") }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    WButton { icon: "vertical_align_top"; label: Translation.tr("Top"); toggled: !Config.options.bar.bottom; onClicked: { Config.options.bar.bottom = false; } }
                    WButton { icon: "vertical_align_bottom"; label: Translation.tr("Bottom"); toggled: Config.options.bar.bottom; onClicked: { Config.options.bar.bottom = true; } }
                }
                Caption { text: Translation.tr("Bar style") }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    WButton { icon: "pill"; label: Translation.tr("Floating"); toggled: Config.options.bar.cornerStyle === 1; onClicked: { Config.options.bar.cornerStyle = 1; } }
                    WButton { icon: "web_asset"; label: Translation.tr("Hugging corners"); toggled: Config.options.bar.cornerStyle === 0; onClicked: { Config.options.bar.cornerStyle = 0; } }
                    WButton { icon: "crop_16_9"; label: Translation.tr("Flat"); toggled: Config.options.bar.cornerStyle === 2; onClicked: { Config.options.bar.cornerStyle = 2; } }
                }
                Caption { text: Translation.tr("Transparency") }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    WButton { icon: "opacity"; label: Translation.tr("Frosted"); toggled: Config.options.appearance.transparency.enable; onClicked: Config.options.appearance.transparency.enable = true }
                    WButton { icon: "square"; label: Translation.tr("Solid"); toggled: !Config.options.appearance.transparency.enable; onClicked: Config.options.appearance.transparency.enable = false }
                }
                StyledText {
                    Layout.topMargin: 10
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: Translation.tr("Much more lives in Settings → Bar and Appearance.")
                    color: Appearance.colors.colSubtext
                    font.pixelSize: Appearance.font.pixelSize.small
                }
            }

            WPage {
                idx: 4
                readonly property var binds: [
                    { keys: ["Super", "Space"], what: Translation.tr("App launcher and search"), line: "bind = SUPER, SPACE, global, quickshell:launcherToggle" },
                    { keys: ["Super", "Tab"], what: Translation.tr("Workspace overview"), line: "bind = SUPER, TAB, global, quickshell:overviewWorkspacesToggle" },
                    { keys: ["Super", "V"], what: Translation.tr("Clipboard history"), line: "bind = SUPER, V, global, quickshell:overviewClipboardToggle" },
                    { keys: ["Super", "."], what: Translation.tr("Emoji picker"), line: "bind = SUPER, PERIOD, global, quickshell:overviewEmojiToggle" },
                    { keys: ["Super", "I"], what: Translation.tr("Settings"), line: "bind = SUPER, I, exec, qs -p ~/.local/share/hydro/nexus.qml" }
                ]
                property bool copied: false

                Heading { Layout.fillWidth: true; icon: "keyboard"; shape: MaterialShape.Shape.Pill; title: Translation.tr("Shortcuts"); sub: Translation.tr("Suggested keys. Hydro doesn't change your Hyprland config, so copy these into it.") }

                Repeater {
                    model: parent.parent.binds
                    Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        implicitHeight: 52
                        radius: 16
                        color: Appearance.colors.colLayer1
                        RowLayout {
                            anchors { fill: parent; leftMargin: 18; rightMargin: 18 }
                            spacing: 10
                            Row {
                                spacing: 6
                                Repeater {
                                    model: modelData.keys
                                    Rectangle {
                                        required property string modelData
                                        implicitWidth: kt.implicitWidth + 20; implicitHeight: 30; radius: 9
                                        color: Appearance.colors.colSecondaryContainer
                                        StyledText { id: kt; anchors.centerIn: parent; text: modelData; font.family: Appearance.font.family.monospace; font.pixelSize: Appearance.font.pixelSize.small; color: Appearance.colors.colOnSecondaryContainer }
                                    }
                                }
                            }
                            StyledText { Layout.fillWidth: true; Layout.leftMargin: 8; text: modelData.what; font.pixelSize: Appearance.font.pixelSize.normal; color: Appearance.colors.colOnLayer1 }
                        }
                    }
                }
                WButton {
                    Layout.topMargin: 6
                    icon: parent.parent.copied ? "check" : "content_copy"
                    label: parent.parent.copied ? Translation.tr("Copied") : Translation.tr("Copy Hyprland binds")
                    onClicked: {
                        Quickshell.clipboardText = parent.parent.binds.map(b => b.line).join("\n");
                        parent.parent.copied = true;
                    }
                }
            }

            WPage {
                idx: 5
                Item { Layout.fillWidth: true; Layout.preferredHeight: 150
                    MaterialShape {
                        anchors.centerIn: parent
                        shape: MaterialShape.Shape.Cookie9Sided
                        implicitSize: 140
                        color: Appearance.colors.colTertiaryContainer
                        scale: root.step === 5 ? 1 : 0.6
                        Behavior on scale { NumberAnimation { duration: 700; easing.type: Easing.OutBack } }
                        MaterialSymbol { anchors.centerIn: parent; text: "check"; iconSize: 64; color: Appearance.colors.colOnTertiaryContainer }
                    }
                }
                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: Translation.tr("You're all set")
                    color: Appearance.colors.colOnLayer0
                    font.family: Appearance.font.family.expressive
                    font.pixelSize: 54
                    font.weight: Font.DemiBold
                }
                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 520
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    text: Translation.tr("Everything you picked can be changed any time in Settings. You can reopen this guide from Settings → Advanced.")
                    color: Appearance.colors.colSubtext
                    font.pixelSize: Appearance.font.pixelSize.larger
                }
                Flow {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 640
                    Layout.topMargin: 6
                    spacing: 8
                    SummaryPill { icon: "wallpaper"; text: Config.options.background.wallpaperPath.length > 0 ? decodeURIComponent(Config.options.background.wallpaperPath.split("/").pop()) : Translation.tr("Default wallpaper") }
                    SummaryPill { icon: Appearance.m3colors.darkmode ? "dark_mode" : "light_mode"; text: Appearance.m3colors.darkmode ? Translation.tr("Dark") : Translation.tr("Light") }
                    SummaryPill { icon: "palette"; text: Config.options.appearance.palette.type.replace("scheme-", "") }
                    SummaryPill { icon: "dock_to_bottom"; text: (Config.options.bar.bottom ? Translation.tr("Bar at bottom") : Translation.tr("Bar on top")) }
                }
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 16
                    spacing: 12
                    WButton { kind: "filled"; icon: "check"; label: Translation.tr("Finish"); onClicked: root.close() }
                    WButton { icon: "settings"; label: Translation.tr("Open Settings"); onClicked: { root.openSettings(); root.close() } }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            implicitHeight: 84
            opacity: root.step > 0 && root.step < root.lastStep ? 1 : 0
            visible: opacity > 0.01
            Behavior on opacity { NumberAnimation { duration: 250 } }
            RowLayout {
                anchors { fill: parent; leftMargin: 40; rightMargin: 40 }
                WButton { kind: "outline"; icon: "arrow_back"; label: Translation.tr("Back"); onClicked: root.go(root.step - 1) }
                Item { Layout.fillWidth: true }
                StyledText { text: root.stepNames[root.step]; color: Appearance.colors.colSubtext; font.pixelSize: Appearance.font.pixelSize.small }
                Item { Layout.fillWidth: true }
                WButton {
                    kind: "filled"
                    icon: root.step === root.lastStep - 1 ? "check" : "arrow_forward"
                    label: root.step === root.lastStep - 1 ? Translation.tr("Finish") : Translation.tr("Next")
                    onClicked: root.go(root.step + 1)
                }
            }
        }
    }
    } // card

    Item {
        id: introLayer
        anchors.fill: parent
        z: 100
        visible: !done
        property bool done: false
        readonly property real reach: Math.sqrt(width * width + height * height)

        Rectangle {
            id: iris
            anchors.centerIn: parent
            property real hole: 0                       // hole diameter
            readonly property real ring: introLayer.reach * 1.2
            width: hole + ring * 2
            height: width
            radius: width / 2
            color: "transparent"
            border.width: ring
            border.color: "#000000"
        }

        SequentialAnimation {
            id: introAnim
            running: true
            PauseAnimation { duration: 450 }
            ScriptAction { script: root.intro = false }
            NumberAnimation { target: iris; property: "hole"; to: introLayer.reach * 1.1; duration: 1100; easing.type: Easing.InOutCubic }
            ScriptAction { script: introLayer.done = true }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                introAnim.stop();
                root.intro = false;
                introLayer.done = true;
            }
        }
    }
}
