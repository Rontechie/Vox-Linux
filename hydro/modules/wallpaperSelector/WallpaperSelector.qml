import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: scope

    PanelWindow {
        id: panel
        readonly property HyprlandMonitor monitor: Hyprland.monitorFor(panel.screen)
        readonly property bool monitorIsFocused: Hyprland.focusedMonitor?.id == monitor?.id
        readonly property bool open: GlobalStates.wallpaperSelectorOpen
        property bool closing: false
        visible: (open && monitorIsFocused) || closing

        property string source: "wallpaper"      // builtin | wallpaper | pictures | favorites
        property string currentDir: ""
        property var history: []
        property bool flatten: false
        property string typeFilter: "all"        // all | jpg | png | webp | gif
        property int sortMode: 0                 // 0 newest, 1 oldest, 2 A-Z, 3 Z-A
        property string modeChoice: "all"        // all (= keep) | dark | light
        property string dropOpen: ""
        property var raw: []                     // everything found by the last scan
        property var shown: []                   // raw after filters / sort / search
        property string query: ""

        readonly property var modeArg: modeChoice === "dark" ? true : (modeChoice === "light" ? false : undefined)
        readonly property string wallpapersRoot: FileUtils.trimFileProtocol(Wallpapers.defaultFolder.toString())
        readonly property string picturesRoot: FileUtils.trimFileProtocol(Directories.pictures.toString())
        readonly property string builtinRoot: FileUtils.trimFileProtocol(Quickshell.shellPath("assets/images"))
        readonly property string rootDir: source === "builtin" ? builtinRoot : (source === "pictures" ? picturesRoot : wallpapersRoot)
        readonly property var favorites: Config.options.wallpaperSelector.favorites

        function closeIt() { GlobalStates.wallpaperSelectorOpen = false }

        onOpenChanged: {
            if (!open) { closing = true; closeTimer.restart(); }
            else { closing = false; closeTimer.stop(); }
        }
        Timer { id: closeTimer; interval: 380; onTriggered: panel.closing = false }

        function baseName(p) { return p.substring(p.lastIndexOf("/") + 1); }
        function parentDir(p) { const i = p.lastIndexOf("/"); return i > 0 ? p.substring(0, i) : "/"; }
        function isImage(name) { return /\.(jpe?g|png|webp|gif|bmp|avif|svg)$/i.test(name); }

        function rescan() {
            if (source === "favorites") {
                raw = favorites.map(p => ({ name: baseName(p), path: p, isDir: false, mtime: 0 }));
                rebuild();
                return;
            }
            if (currentDir === "") currentDir = rootDir;
            const cmd = ["find", currentDir, "-mindepth", "1"];
            if (flatten) cmd.push("-maxdepth", "6", "-not", "-path", "*/.*", "-type", "f");
            else cmd.push("-maxdepth", "1", "-not", "-name", ".*", "(", "-type", "d", "-o", "-type", "f", ")");
            cmd.push("-printf", "%y\\t%T@\\t%p\\n");
            scan.exec(cmd);
        }
        function parseScan(text) {
            const out = [];
            for (const line of text.split("\n")) {
                if (!line) continue;
                const parts = line.split("\t");
                if (parts.length < 3) continue;
                const path = parts.slice(2).join("\t");
                const isDir = parts[0] === "d";
                const name = baseName(path);
                if (!isDir && !isImage(name)) continue;
                out.push({ name: name, path: path, isDir: isDir, mtime: parseFloat(parts[1]) || 0 });
            }
            raw = out;
            rebuild();
        }
        function rebuild() {
            const q = query.trim().toLowerCase();
            let list = raw.filter(it => {
                if (q !== "" && it.name.toLowerCase().indexOf(q) < 0) return false;
                if (!it.isDir && typeFilter !== "all") {
                    const ext = it.name.split(".").pop().toLowerCase();
                    if (typeFilter === "jpg" ? !(ext === "jpg" || ext === "jpeg") : ext !== typeFilter) return false;
                }
                return true;
            });
            list.sort((a, b) => {
                if (a.isDir !== b.isDir) return a.isDir ? -1 : 1;   // folders first
                switch (sortMode) {
                    case 0: return b.mtime - a.mtime;
                    case 1: return a.mtime - b.mtime;
                    case 2: return a.name.localeCompare(b.name, undefined, { numeric: true });
                    default: return b.name.localeCompare(a.name, undefined, { numeric: true });
                }
            });
            shown = list;
            focusCurrent();
        }
        function focusCurrent() {
            const cur = Config.options.background.wallpaperPath;
            for (let i = 0; i < shown.length; i++) {
                if (shown[i].path === cur) { grid.currentIndex = i; grid.positionViewAtIndex(i, GridView.Center); return; }
            }
            grid.currentIndex = shown.length > 0 ? 0 : -1;
        }
        Process {
            id: scan
            stdout: StdioCollector { onStreamFinished: panel.parseScan(text) }
        }

        function setSource(s) {
            source = s; history = []; currentDir = ""; flatten = flatten && s !== "favorites";
            if (s !== "favorites") currentDir = rootDir;
            rescan();
        }
        function enterDir(p) { history = history.concat([currentDir]); currentDir = p; rescan(); }
        function goBack() {
            if (history.length === 0) return;
            currentDir = history[history.length - 1];
            history = history.slice(0, history.length - 1);
            rescan();
        }
        function goUp() {
            if (source === "favorites" || currentDir === "" || currentDir === "/") return;
            history = history.concat([currentDir]);
            currentDir = parentDir(currentDir);
            rescan();
        }
        function toggleFav(path) {
            const f = Array.from(Config.options.wallpaperSelector.favorites);
            const i = f.indexOf(path);
            if (i >= 0) f.splice(i, 1); else f.push(path);
            Config.options.wallpaperSelector.favorites = f;
            if (source === "favorites") rescan();
        }
        function activate(i) {
            if (i < 0 || i >= shown.length) return;
            const it = shown[i];
            if (it.isDir) { enterDir(it.path); return; }
            Wallpapers.apply(it.path, modeArg);
            closeIt();
        }
        function randomPick() {
            const files = shown.filter(it => !it.isDir);
            if (files.length === 0) return;
            Wallpapers.apply(files[Math.floor(Math.random() * files.length)].path, modeArg);
            closeIt();
        }

        onQueryChanged: rebuild()
        onSortModeChanged: rebuild()
        onTypeFilterChanged: rebuild()
        onFlattenChanged: rescan()
        onFavoritesChanged: if (source === "favorites") rescan()

        onVisibleChanged: {
            if (visible && open) {
                Wallpapers.load();
                dropOpen = "";
                search.text = "";
                query = "";
                if (currentDir === "") currentDir = rootDir;
                rescan();
                search.forceActiveFocus();
            }
        }

        WlrLayershell.namespace: "quickshell:wallpaperSelector"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: panel.open ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
        color: "transparent"
        anchors { top: true; bottom: true; left: true; right: true }

        MouseArea { anchors.fill: parent; onClicked: panel.closeIt() }

        Rectangle {
            id: notch
            readonly property bool expanded: panel.open
            readonly property real fullW: Math.min(panel.width - 80, 1180)
            readonly property real fullH: Math.min(panel.height - 90, 700)
            readonly property real r: 34

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: -r
            width: expanded ? fullW : 176
            height: (expanded ? fullH : 36) + r
            radius: r
            color: Appearance.colors.colLayer0
            border.width: 1
            border.color: Appearance.colors.colLayer0Border
            Behavior on width { NumberAnimation { duration: 460; easing.type: Easing.OutBack; easing.overshoot: 1.05 } }
            Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.OutBack; easing.overshoot: 1.15 } }

            MouseArea { anchors.fill: parent; onClicked: panel.dropOpen = "" }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                y: notch.r + 7
                spacing: 6
                opacity: notch.expanded ? 0 : 1
                Behavior on opacity { NumberAnimation { duration: 120 } }
                MaterialSymbol { text: "wallpaper"; iconSize: 18; color: Appearance.colors.colSubtext }
                StyledText { text: Translation.tr("Wallpapers"); color: Appearance.colors.colSubtext; font.pixelSize: Appearance.font.pixelSize.smaller }
            }

            component IconBtn: Rectangle {
                id: ib
                property string icon: ""
                property bool active: false
                signal clicked()
                implicitWidth: 42; implicitHeight: 42
                radius: 14
                color: active ? Appearance.colors.colPrimaryContainer : (im.containsMouse ? Appearance.colors.colLayer1Hover : Appearance.colors.colLayer1)
                border.width: 1
                border.color: Appearance.colors.colOutlineVariant
                Behavior on color { ColorAnimation { duration: 140 } }
                scale: im.pressed ? 0.92 : 1
                Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutBack } }
                MaterialSymbol { anchors.centerIn: parent; text: ib.icon; iconSize: 20; color: Appearance.colors.colOnLayer1 }
                MouseArea { id: im; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: ib.clicked() }
            }

            component Tab: Rectangle {
                id: tab
                property string label: ""
                property string icon: ""
                property bool selected: false
                signal clicked()
                implicitHeight: 42
                implicitWidth: tabRow.implicitWidth + 32
                radius: 12
                color: selected ? Appearance.colors.colPrimary : (tm.containsMouse ? Appearance.colors.colLayer1Hover : Appearance.colors.colLayer1)
                Behavior on color { ColorAnimation { duration: 140 } }
                Row {
                    id: tabRow
                    anchors.centerIn: parent
                    spacing: 6
                    MaterialSymbol {
                        visible: tab.icon !== ""
                        anchors.verticalCenter: parent.verticalCenter
                        text: tab.icon; iconSize: 20; fill: tab.selected ? 1 : 0
                        color: tab.selected ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
                    }
                    StyledText {
                        visible: tab.label !== ""
                        anchors.verticalCenter: parent.verticalCenter
                        text: tab.label
                        font.weight: Font.Medium
                        color: tab.selected ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
                    }
                }
                MouseArea { id: tm; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: tab.clicked() }
            }

            component Dropdown: Item {
                id: dd
                property string name: ""
                property var options: []          // [{ value, text }]
                property string current: ""
                property string openName: ""      // bound to the panel's currently open dropdown
                signal picked(string value)
                signal toggled()
                readonly property bool isOpen: dd.openName === dd.name
                readonly property string currentText: {
                    for (const o of dd.options) if (o.value === dd.current) return o.text;
                    return dd.current;
                }
                implicitHeight: 42
                implicitWidth: Math.max(112, ddRow.implicitWidth + 30)
                z: isOpen ? 50 : 0

                Rectangle {
                    anchors.fill: parent
                    radius: 12
                    color: dm.containsMouse ? Appearance.colors.colLayer1Hover : Appearance.colors.colLayer1
                    border.width: 1
                    border.color: dd.isOpen ? Appearance.colors.colPrimary : Appearance.colors.colOutlineVariant
                    Row {
                        id: ddRow
                        anchors.centerIn: parent
                        spacing: 10
                        StyledText { anchors.verticalCenter: parent.verticalCenter; text: dd.currentText; color: Appearance.colors.colOnLayer1 }
                        MaterialSymbol { anchors.verticalCenter: parent.verticalCenter; text: dd.isOpen ? "expand_less" : "expand_more"; iconSize: 20; color: Appearance.colors.colSubtext }
                    }
                    MouseArea {
                        id: dm
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dd.toggled()
                    }
                }
                Rectangle {
                    visible: dd.isOpen
                    y: dd.height + 6
                    anchors.right: parent.right
                    width: Math.max(dd.width, 150)
                    height: optCol.implicitHeight + 12
                    radius: 14
                    color: Appearance.colors.colLayer2
                    border.width: 1
                    border.color: Appearance.colors.colOutlineVariant
                    Column {
                        id: optCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 6 }
                        spacing: 2
                        Repeater {
                            model: dd.options
                            delegate: Rectangle {
                                id: opt
                                required property var modelData
                                width: optCol.width
                                height: 38
                                radius: 9
                                color: om.containsMouse ? Appearance.colors.colLayer1Hover : (modelData.value === dd.current ? Appearance.colors.colPrimaryContainer : "transparent")
                                StyledText {
                                    anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 14 }
                                    text: opt.modelData.text
                                    color: Appearance.colors.colOnLayer1
                                }
                                MouseArea {
                                    id: om
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: dd.picked(opt.modelData.value)
                                }
                            }
                        }
                    }
                }
            }

            Item {
                id: content
                anchors {
                    top: parent.top; topMargin: notch.r + 14
                    left: parent.left; right: parent.right
                    bottom: parent.bottom; bottomMargin: notch.r + 14
                    leftMargin: 24; rightMargin: 24
                }
                opacity: notch.expanded ? 1 : 0
                visible: opacity > 0.01
                Behavior on opacity { NumberAnimation { duration: notch.expanded ? 260 : 90 } }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        z: 20

                        StyledText {
                            text: Translation.tr("Wallpaper")
                            font.pixelSize: Appearance.font.pixelSize.larger
                            font.weight: Font.Bold
                            color: Appearance.colors.colPrimary
                        }
                        Rectangle {
                            Layout.preferredWidth: 340
                            implicitHeight: 42
                            radius: 10
                            color: Appearance.colors.colLayer1
                            border.width: 2
                            border.color: search.activeFocus ? Appearance.colors.colPrimary : Appearance.colors.colOutlineVariant
                            TextInput {
                                id: search
                                anchors { fill: parent; leftMargin: 14; rightMargin: 14 }
                                verticalAlignment: TextInput.AlignVCenter
                                color: Appearance.colors.colOnLayer1
                                font.family: Appearance.font.family.main
                                font.pixelSize: Appearance.font.pixelSize.normal
                                selectByMouse: true
                                clip: true
                                onTextChanged: panel.query = text
                                Keys.onPressed: event => {
                                    if (event.key === Qt.Key_Escape) {
                                        if (panel.dropOpen !== "") panel.dropOpen = ""; else panel.closeIt();
                                        event.accepted = true;
                                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                        panel.activate(grid.currentIndex); event.accepted = true;
                                    } else if (event.key === Qt.Key_Right && (text.length === 0 || cursorPosition === text.length)) {
                                        grid.moveCurrentIndexRight(); event.accepted = true;
                                    } else if (event.key === Qt.Key_Left && (text.length === 0 || cursorPosition === 0)) {
                                        grid.moveCurrentIndexLeft(); event.accepted = true;
                                    } else if (event.key === Qt.Key_Down) {
                                        grid.moveCurrentIndexDown(); event.accepted = true;
                                    } else if (event.key === Qt.Key_Up) {
                                        grid.moveCurrentIndexUp(); event.accepted = true;
                                    } else if (event.key === Qt.Key_Backspace && text.length === 0) {
                                        panel.goUp(); event.accepted = true;
                                    }
                                }
                                StyledText {
                                    visible: search.text.length === 0
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: Translation.tr("Filter...")
                                    color: Appearance.colors.colSubtext
                                }
                            }
                        }

                        Item { Layout.fillWidth: true }

                        StyledText { text: Translation.tr("Flatten"); color: Appearance.colors.colOnLayer1 }
                        Rectangle {
                            id: sw
                            implicitWidth: 58; implicitHeight: 32
                            radius: 16
                            color: panel.flatten ? Appearance.colors.colPrimary : Appearance.colors.colLayer1
                            border.width: panel.flatten ? 0 : 2
                            border.color: Appearance.colors.colOutline
                            Behavior on color { ColorAnimation { duration: 160 } }
                            Rectangle {
                                width: panel.flatten ? 24 : 18; height: width; radius: width / 2
                                anchors.verticalCenter: parent.verticalCenter
                                x: panel.flatten ? parent.width - width - 4 : 7
                                color: panel.flatten ? Appearance.colors.colOnPrimary : Appearance.colors.colOutline
                                Behavior on x { NumberAnimation { duration: 220; easing.type: Easing.OutBack } }
                                Behavior on width { NumberAnimation { duration: 160 } }
                            }
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: panel.flatten = !panel.flatten }
                        }

                        Dropdown {
                            name: "type"
                            openName: panel.dropOpen
                            onToggled: panel.dropOpen = panel.dropOpen === "type" ? "" : "type"
                            current: panel.typeFilter
                            options: [
                                { value: "all", text: Translation.tr("ALL") },
                                { value: "jpg", text: "JPG" },
                                { value: "png", text: "PNG" },
                                { value: "webp", text: "WEBP" },
                                { value: "gif", text: "GIF" }
                            ]
                            onPicked: v => { panel.dropOpen = ""; panel.typeFilter = v; }
                        }
                        IconBtn { icon: "edit"; onClicked: { panel.closeIt(); Wallpapers.openFallbackPicker(panel.modeArg); } }
                        IconBtn {
                            icon: panel.sortMode === 3 ? "arrow_upward" : "sort_by_alpha"
                            active: panel.sortMode >= 2
                            onClicked: panel.sortMode = panel.sortMode === 2 ? 3 : 2
                        }
                        IconBtn { icon: "refresh"; onClicked: panel.rescan() }
                        IconBtn { icon: "close"; onClicked: panel.closeIt() }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        z: 10

                        Tab { label: Translation.tr("Built-In"); selected: panel.source === "builtin"; onClicked: panel.setSource("builtin") }
                        Tab { label: Translation.tr("Wallpaper"); selected: panel.source === "wallpaper"; onClicked: panel.setSource("wallpaper") }
                        Tab { label: Translation.tr("Pictures"); selected: panel.source === "pictures"; onClicked: panel.setSource("pictures") }
                        Tab { icon: "star"; selected: panel.source === "favorites"; onClicked: panel.setSource("favorites") }

                        Tab {
                            icon: panel.sortMode === 1 ? "history" : "schedule"
                            label: panel.sortMode === 0 ? Translation.tr("Newest") : (panel.sortMode === 1 ? Translation.tr("Oldest") : Translation.tr("By date"))
                            selected: panel.sortMode <= 1
                            onClicked: panel.sortMode = panel.sortMode === 0 ? 1 : 0
                        }

                        Item { Layout.fillWidth: true }

                        Dropdown {
                            name: "fit"
                            openName: panel.dropOpen
                            onToggled: panel.dropOpen = panel.dropOpen === "fit" ? "" : "fit"
                            current: Config.options.background.fillMode
                            options: [
                                { value: "crop", text: Translation.tr("Crop") },
                                { value: "fit", text: Translation.tr("Fit") },
                                { value: "stretch", text: Translation.tr("Stretch") },
                                { value: "center", text: Translation.tr("Center") },
                                { value: "tile", text: Translation.tr("Tile") }
                            ]
                            onPicked: v => { panel.dropOpen = ""; Config.options.background.fillMode = v; }
                        }
                        Tab { label: Translation.tr("Dark"); selected: panel.modeChoice === "dark"; onClicked: panel.modeChoice = "dark" }
                        Tab { label: Translation.tr("Light"); selected: panel.modeChoice === "light"; onClicked: panel.modeChoice = "light" }
                        Tab { label: Translation.tr("Auto"); selected: panel.modeChoice === "all"; onClicked: panel.modeChoice = "all" }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        IconBtn { implicitWidth: 30; implicitHeight: 30; icon: "arrow_back"; onClicked: panel.goBack() }
                        IconBtn { implicitWidth: 30; implicitHeight: 30; icon: "arrow_upward"; onClicked: panel.goUp() }
                        StyledText {
                            Layout.fillWidth: true
                            elide: Text.ElideMiddle
                            text: panel.source === "favorites" ? Translation.tr("Favorites") : panel.currentDir
                            color: Appearance.colors.colSubtext
                            font.pixelSize: Appearance.font.pixelSize.smaller
                        }
                        StyledText {
                            text: panel.shown.length + " " + Translation.tr("items")
                            color: Appearance.colors.colSubtext
                            font.pixelSize: Appearance.font.pixelSize.smaller
                        }
                    }

                    GridView {
                        id: grid
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        readonly property int columns: Math.max(3, Math.floor(width / 190))
                        cellWidth: Math.floor(width / columns)
                        cellHeight: Math.round(cellWidth * 0.62) + 34
                        model: panel.shown
                        boundsBehavior: Flickable.StopAtBounds
                        highlightFollowsCurrentItem: false
                        keyNavigationWraps: false
                        ScrollBar.vertical: StyledScrollBar {}

                        delegate: Item {
                            id: cell
                            required property int index
                            required property var modelData
                            readonly property bool isDir: modelData.isDir
                            readonly property bool isCurrent: !isDir && modelData.path === Config.options.background.wallpaperPath
                            readonly property bool focused: GridView.isCurrentItem
                            readonly property bool isFav: !isDir && panel.favorites.indexOf(modelData.path) >= 0
                            width: grid.cellWidth
                            height: grid.cellHeight

                            Rectangle {
                                id: tile
                                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 7 }
                                height: parent.height - 34 - 7
                                radius: 12
                                color: Appearance.colors.colLayer1
                                clip: true
                                border.width: cell.isCurrent ? 3 : (cell.focused ? 2 : 0)
                                border.color: cell.isCurrent ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer1
                                scale: tm.pressed ? 0.97 : ((cell.focused || tm.containsMouse) ? 1.03 : 1)
                                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

                                StyledImage {
                                    visible: !cell.isDir
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectCrop
                                    source: cell.isDir ? "" : Qt.resolvedUrl(cell.modelData.path)
                                    cache: false
                                    sourceSize: Qt.size(380, 240)
                                }
                                MaterialSymbol {
                                    visible: cell.isDir
                                    anchors.centerIn: parent
                                    text: "folder"; fill: 0; iconSize: 66
                                    color: Appearance.colors.colPrimary
                                }
                                Rectangle {
                                    visible: cell.isCurrent
                                    anchors { top: parent.top; left: parent.left; margins: 8 }
                                    width: 26; height: 26; radius: 13
                                    color: Appearance.colors.colPrimary
                                    MaterialSymbol { anchors.centerIn: parent; text: "check"; iconSize: 18; color: Appearance.colors.colOnPrimary }
                                }
                                Rectangle {
                                    visible: !cell.isDir && (tm.containsMouse || cell.isFav || cell.focused)
                                    anchors { top: parent.top; right: parent.right; margins: 8 }
                                    width: 30; height: 30; radius: 15
                                    color: Qt.rgba(0, 0, 0, starMouse.containsMouse ? 0.7 : 0.5)
                                    MaterialSymbol {
                                        anchors.centerIn: parent
                                        text: "star"; fill: cell.isFav ? 1 : 0; iconSize: 19
                                        color: cell.isFav ? "#ffd54f" : "white"
                                    }
                                    MouseArea {
                                        id: starMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: panel.toggleFav(cell.modelData.path)
                                    }
                                }
                                MouseArea {
                                    id: tm
                                    anchors.fill: parent
                                    z: -1
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: { grid.currentIndex = cell.index; panel.activate(cell.index); }
                                }
                            }
                            StyledText {
                                anchors { left: parent.left; right: parent.right; bottom: parent.bottom; leftMargin: 8; rightMargin: 8; bottomMargin: 4 }
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideMiddle
                                text: cell.modelData.name
                                color: cell.isCurrent ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer1
                                font.pixelSize: Appearance.font.pixelSize.small
                            }
                        }

                        ColumnLayout {
                            visible: panel.shown.length === 0
                            anchors.centerIn: parent
                            spacing: 6
                            MaterialSymbol { Layout.alignment: Qt.AlignHCenter; text: panel.source === "favorites" ? "star" : "image_not_supported"; iconSize: 40; color: Appearance.colors.colSubtext }
                            StyledText {
                                Layout.alignment: Qt.AlignHCenter
                                horizontalAlignment: Text.AlignHCenter
                                color: Appearance.colors.colSubtext
                                text: panel.source === "favorites"
                                    ? Translation.tr("No favourites yet.\nHover a wallpaper and tap the star.")
                                    : Translation.tr("No images here.\nPut some in ~/Pictures/Wallpapers or switch tab.")
                            }
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "wallpaperSelector"
        function toggle(): void { GlobalStates.wallpaperSelectorOpen = !GlobalStates.wallpaperSelectorOpen }
        function open(): void { GlobalStates.wallpaperSelectorOpen = true }
        function close(): void { GlobalStates.wallpaperSelectorOpen = false }
        function random(): void { Wallpapers.randomFromCurrentFolder() }
    }

    GlobalShortcut {
        name: "wallpaperSelectorToggle"
        description: "Toggles the wallpaper selector"
        onPressed: GlobalStates.wallpaperSelectorOpen = !GlobalStates.wallpaperSelectorOpen
    }
    GlobalShortcut {
        name: "wallpaperSelectorRandom"
        description: "Applies a random wallpaper from the current folder"
        onPressed: Wallpapers.randomFromCurrentFolder()
    }
}
