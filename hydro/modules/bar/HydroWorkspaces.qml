import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Hyprland
import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects

Item {
    id: root
    readonly property var wsCfg: Config.options.bar.workspaces
    readonly property string theme: wsCfg.theme
    function appIconFor(id) { // icon of the first window on that workspace
        const wins = HyprlandData.windowList.filter(w => w.workspace?.id === id);
        return wins.length === 0 ? "" : Quickshell.iconPath(AppSearch.guessIcon(wins[0].class), "image-missing");
    }
    function isOccupied(id) {
        return HyprlandData.windowList.some(w => w.workspace?.id === id);
    }
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.QsWindow.window?.screen)
    readonly property int activeId: monitor?.activeWorkspace?.id ?? 1
    readonly property var shownIds: {
        const ids = [];
        for (let i = 1; i <= root.wsCfg.shown; i++) ids.push(i);
        if (root.activeId > root.wsCfg.shown) ids.push(root.activeId);
        return ids;
    }
    readonly property int lastShown: shownIds.length > 0 ? shownIds[shownIds.length - 1] : 1

    property bool facingLeft: false
    property int prevActive: activeId
    onActiveIdChanged: {
        facingLeft = activeId < prevActive;
        prevActive = activeId;
    }

    implicitWidth: row.implicitWidth + (theme === "pills" ? 12 : 20)
    readonly property var caps: Config.options.bar.capsules
    readonly property real ws: Config.options.bar.sizes.widgetScale
    readonly property real fs: Config.options.bar.sizes.fontScale
    implicitHeight: Math.min(Appearance.sizes.baseBarHeight, Math.round(Appearance.sizes.baseBarHeight * caps.thickness * ws))
    Behavior on implicitWidth { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }

    Rectangle {
        anchors.fill: parent
        radius: root.caps.radiusAuto ? height / 2 * Math.min(1, Appearance.rScale) : Math.min(root.caps.radius, height / 2)
        color: root.caps.enable ? Appearance.capsuleFill : "transparent"
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: root.theme === "dots" ? 4 : (root.theme === "pacman" ? 0 : 4)
        Repeater {
            id: rep
            model: root.shownIds
            delegate: Item {
                id: slot
                required property var modelData
                readonly property int wsId: modelData
                readonly property bool isActive: wsId === root.activeId
                readonly property bool occupied: root.isOccupied(wsId)
                readonly property bool hot: mouse.containsMouse
                readonly property real pad: root.theme === "dots" ? 3 : 0 // bigger click target for tiny dots

                anchors.verticalCenter: parent.verticalCenter
                width: ld.item ? ld.item.width + pad * 2 : 0
                height: ld.item ? ld.item.height : 0

                Loader {
                    id: ld
                    anchors.centerIn: parent
                    sourceComponent: root.theme === "pacman" ? pacC
                                   : root.theme === "dots" ? dotC
                                   : root.theme === "numbers" ? numC : pillC
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch(`hl.dsp.focus({workspace = ${slot.wsId}})`)
                }

                Component {
                    id: pillC
                    Rectangle {
                        id: chip
                        readonly property string appIcon: root.wsCfg.showAppIcons ? root.appIconFor(slot.wsId) : ""
                        width: Math.max((slot.isActive ? 44 : 24) * root.ws, chipContent.implicitWidth + 16)
                        height: slot.isActive ? root.implicitHeight - 8 : root.implicitHeight - 10
                        radius: height / 2
                        color: slot.isActive ? Appearance.colors.colPrimary : (slot.hot ? "#40ffffff" : "#1fffffff")
                        scale: mouse.pressed ? 0.85 : (slot.hot && !slot.isActive ? 1.12 : 1)
                        Behavior on width { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }
                        Behavior on height { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
                        Behavior on scale { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
                        Behavior on color { ColorAnimation { duration: 150 } }

                        Row {
                            id: chipContent
                            anchors.centerIn: parent
                            spacing: 4
                            IconImage {
                                visible: chip.appIcon !== ""
                                anchors.verticalCenter: parent.verticalCenter
                                implicitSize: 14 * root.ws
                                source: chip.appIcon
                                layer.enabled: root.wsCfg.monochromeIcons
                                layer.effect: Desaturate { desaturation: 1.0 }
                            }
                            StyledText {
                                anchors.verticalCenter: parent.verticalCenter
                                text: slot.wsId
                                font.pixelSize: Appearance.font.pixelSize.smaller * root.fs
                                font.weight: slot.isActive ? Font.Bold : Font.Medium
                                color: slot.isActive ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer0
                                opacity: slot.isActive ? 1 : 0.75
                            }
                        }
                    }
                }

                Component {
                    id: numC
                    Item {
                        width: numText.implicitWidth + 14
                        height: root.implicitHeight - 6
                        StyledText {
                            id: numText
                            anchors.centerIn: parent
                            text: slot.wsId
                            font.pixelSize: (Appearance.font.pixelSize.smaller + 1) * root.fs
                            font.weight: slot.isActive ? Font.Bold : Font.Medium
                            color: slot.isActive ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer0
                            opacity: slot.isActive ? 1 : (slot.occupied ? 0.85 : 0.4)
                            scale: slot.isActive ? 1.2 : (slot.hot ? 1.1 : 1)
                            Behavior on scale { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                        Rectangle { // underline under the active number
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 2
                            height: 3
                            radius: 1.5
                            width: slot.isActive ? numText.implicitWidth : 0
                            color: Appearance.colors.colPrimary
                            Behavior on width { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }
                        }
                    }
                }

                Component {
                    id: dotC
                    Rectangle {
                        width: (slot.isActive ? 22 : (slot.occupied ? 9 : 7)) * root.ws
                        height: (slot.isActive ? 9 : (slot.occupied ? 9 : 7)) * root.ws
                        radius: height / 2
                        color: slot.isActive ? Appearance.colors.colPrimary
                             : slot.occupied ? Appearance.colors.colOnLayer0 : "#59ffffff"
                        opacity: slot.isActive ? 1 : (slot.occupied ? 0.85 : 1)
                        scale: mouse.pressed ? 0.8 : (slot.hot && !slot.isActive ? 1.3 : 1)
                        Behavior on width { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }
                        Behavior on height { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
                        Behavior on scale { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }

                Component {
                    id: pacC
                    Item {
                        id: cell
                        width: 24 * root.ws
                        height: 24 * root.ws
                        readonly property bool eaten: slot.wsId < root.activeId
                        readonly property bool power: slot.wsId === root.lastShown && root.lastShown > root.activeId

                        Rectangle {
                            visible: !slot.isActive && !slot.occupied && !root.wsCfg.pacmanNumbers
                            anchors.centerIn: parent
                            width: (cell.power ? 10 : 5) * root.ws
                            height: width
                            radius: width / 2
                            color: "#FFE9A8"
                            opacity: cell.eaten ? 0.15 : 0.95
                            scale: slot.hot ? 1.4 : 1
                            Behavior on scale { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
                            SequentialAnimation on opacity {
                                running: cell.power && !cell.eaten
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.25; duration: 450 }
                                NumberAnimation { to: 0.95; duration: 450 }
                            }
                        }
                        StyledText {
                            visible: !slot.isActive && !slot.occupied && root.wsCfg.pacmanNumbers
                            anchors.centerIn: parent
                            text: slot.wsId
                            font.pixelSize: Appearance.font.pixelSize.smaller * root.fs
                            font.weight: Font.Medium
                            color: "#FFE9A8"
                            opacity: cell.eaten ? 0.2 : (cell.power ? 1 : 0.9)
                            scale: slot.hot ? 1.25 : 1
                            Behavior on scale { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
                        }

                        Canvas {
                            id: ghost
                            visible: !slot.isActive && slot.occupied
                            anchors.centerIn: parent
                            width: 17 * root.ws
                            height: width
                            readonly property color body: ["#FF3B30", "#FF8FD6", "#2FE0FF", "#FFB347"][slot.wsId % 4]
                            readonly property bool lookLeft: slot.wsId > root.activeId
                            onBodyChanged: requestPaint()
                            onLookLeftChanged: requestPaint()
                            onWidthChanged: requestPaint()
                            onPaint: {
                                const ctx = getContext("2d");
                                ctx.reset();
                                const s = width;
                                ctx.fillStyle = body;
                                ctx.beginPath();
                                ctx.moveTo(0, s);
                                ctx.lineTo(0, s * 0.5);
                                ctx.arc(s / 2, s * 0.5, s / 2, Math.PI, 0, false);
                                ctx.lineTo(s, s);
                                const w = s / 3;
                                for (let i = 0; i < 3; i++) {
                                    ctx.lineTo(s - w * i - w / 2, s * 0.8);
                                    ctx.lineTo(s - w * (i + 1), s);
                                }
                                ctx.closePath();
                                ctx.fill();
                                const dx = lookLeft ? -s * 0.05 : s * 0.05;
                                for (const ex of [s * 0.32, s * 0.68]) {
                                    ctx.fillStyle = "white";
                                    ctx.beginPath();
                                    ctx.ellipse(ex - s * 0.13, s * 0.3, s * 0.26, s * 0.3);
                                    ctx.fill();
                                    ctx.fillStyle = "#1f3bff";
                                    ctx.beginPath();
                                    ctx.arc(ex + dx, s * 0.46, s * 0.07, 0, Math.PI * 2);
                                    ctx.fill();
                                }
                            }
                            SequentialAnimation on rotation { // a little wobble
                                running: ghost.visible
                                loops: Animation.Infinite
                                NumberAnimation { to: 6; duration: 420; easing.type: Easing.InOutSine }
                                NumberAnimation { to: -6; duration: 420; easing.type: Easing.InOutSine }
                            }
                            scale: slot.hot ? 1.2 : 1
                            Behavior on scale { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
                        }
                    }
                }
            }
        }
    }

    Item {
        id: pac
        visible: root.theme === "pacman"
        readonly property Item slotItem: { rep.count; return rep.itemAt(root.shownIds.indexOf(root.activeId)); }
        readonly property real s: 20 * root.ws
        property real mouth: 30 // degrees
        width: s
        height: s
        anchors.verticalCenter: parent.verticalCenter
        x: slotItem ? row.x + slotItem.x + (slotItem.width - width) / 2 : 0
        Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
        transform: Scale { origin.x: pac.width / 2; xScale: root.facingLeft ? -1 : 1 }

        SequentialAnimation on mouth {
            running: pac.visible
            loops: Animation.Infinite
            NumberAnimation { to: 3; duration: 170; easing.type: Easing.InOutSine }
            NumberAnimation { to: 34; duration: 170; easing.type: Easing.InOutSine }
        }
        Shape {
            anchors.fill: parent
            layer.enabled: true
            layer.samples: 4
            ShapePath {
                fillColor: "#FFD60A"
                strokeColor: "transparent"
                PathSvg {
                    path: {
                        const r = pac.s / 2, a = pac.mouth * Math.PI / 180;
                        const x = r + r * Math.cos(a), y1 = r - r * Math.sin(a), y2 = r + r * Math.sin(a);
                        return `M ${r} ${r} L ${x} ${y1} A ${r} ${r} 0 1 0 ${x} ${y2} Z`;
                    }
                }
            }
        }
        Rectangle { // eye
            x: pac.s * 0.52
            y: pac.s * 0.2
            width: Math.max(2, pac.s * 0.14)
            height: width
            radius: width / 2
            color: "#14110a"
        }
    }

    MouseArea { // wheel + right-click (left clicks fall through to the chips)
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: GlobalStates.overviewOpen = !GlobalStates.overviewOpen
        onWheel: wheel => {
            if (wheel.angleDelta.y < 0) Hyprland.dispatch(`hl.dsp.focus({workspace = "r+1"})`);
            else if (wheel.angleDelta.y > 0) Hyprland.dispatch(`hl.dsp.focus({workspace = "r-1"})`);
        }
    }
}
