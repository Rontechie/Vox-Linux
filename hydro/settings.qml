
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.modules.settings.nexus

ApplicationWindow {
    id: root

    readonly property var categories: ["appearance", "connectivity", "system", "shell", "about"]
    readonly property string base: "modules/settings/"
    readonly property var pages: [
        { cat: "appearance",   label: Translation.tr("Wallpaper & style"),  icon: "palette",       desc: Translation.tr("Wallpaper, colours, fonts"),            source: base + "nexus/WallpaperStylePage.qml", kw: "wallpaper theme palette dark light mode scheme font transparency matugen" },
        { cat: "appearance",   label: Translation.tr("Profile"),            icon: "account_circle", desc: Translation.tr("Profile picture"),                      source: base + "nexus/ProfilePage.qml",         kw: "avatar picture photo face user account pfp" },
        { cat: "appearance",   label: Translation.tr("Desktop"),            icon: "wallpaper",     desc: Translation.tr("Parallax, clock, widgets"),             source: base + "BackgroundConfig.qml",         kw: "background clock parallax widgets media" },
        { cat: "connectivity", label: Translation.tr("Network"),            icon: "wifi",          desc: Translation.tr("Wi-Fi, ethernet"),                      source: base + "nexus/NetworkPage.qml",        kw: "wifi wireless internet ethernet ssid password" },
        { cat: "connectivity", label: Translation.tr("Connected devices"),  icon: "devices_other", desc: Translation.tr("Bluetooth, pairing"),                   source: base + "nexus/BluetoothPage.qml",      kw: "bluetooth pair headphones device", noFill: true },
        { cat: "connectivity", label: Translation.tr("Audio"),              icon: "volume_up",     desc: Translation.tr("Volume, sound devices"),                source: base + "nexus/AudioPage.qml",          kw: "sound volume speaker microphone output input mute" },
        { cat: "system",       label: Translation.tr("Updates"),            icon: "update",        desc: Translation.tr("System updates"),                       source: base + "nexus/UpdatesPage.qml",        kw: "update pacman upgrade packages" },
        { cat: "system",       label: Translation.tr("General"),            icon: "settings",      desc: Translation.tr("Battery, sounds, time"),                source: base + "GeneralConfig.qml",            kw: "battery sounds time clock format" },
        { cat: "system",       label: Translation.tr("Advanced"),           icon: "code",          desc: Translation.tr("Color generation, welcome screen"),     source: base + "AdvancedConfig.qml",           kw: "color generation hyprland welcome quickstart" },
        { cat: "shell",        label: Translation.tr("Panels"),             icon: "dock_to_bottom", desc: Translation.tr("Bar, dashboard, launcher, sidebar"),   source: base + "nexus/PanelsPage.qml",         kw: "bar dashboard launcher sidebar dock overview lock corners layout widgets position float" },
        { cat: "shell",        label: Translation.tr("Apps"),               icon: "apps",          desc: Translation.tr("Default apps and commands"),            source: base + "nexus/AppsPage.qml",           kw: "terminal task manager network bluetooth volume mixer command" },
        { cat: "shell",        label: Translation.tr("Services"),           icon: "build",         desc: Translation.tr("Search, polling"),                  source: base + "nexus/ServicesPage.qml",       kw: "search weather poll interval resources" },
        { cat: "shell",        label: Translation.tr("Language & region"),  icon: "globe",         desc: Translation.tr("Language, weather location, units"),    source: base + "nexus/LanguagePage.qml",       kw: "language locale weather city units fahrenheit celsius translate" },
        { cat: "about",        label: Translation.tr("About"),              icon: "info",          desc: Translation.tr("Version, credits"),                     source: base + "hydro/HAboutTab.qml",          kw: "version credits license hydro" }
    ]
    readonly property var catNames: ({
        appearance: Translation.tr("Appearance"), connectivity: Translation.tr("Connectivity"), system: Translation.tr("System"),
        shell: Translation.tr("Shell"), about: Translation.tr("About")
    })

    property int currentIdx: 0
    readonly property string query: searchInput.text.trim().toLowerCase()
    readonly property bool searching: query !== ""
    readonly property var results: {
        if (query === "") return [];
        const out = [];
        for (let i = 0; i < pages.length; i++) {
            const p = pages[i];
            if ((p.label + " " + p.desc + " " + p.kw + " " + catNames[p.cat]).toLowerCase().indexOf(query) >= 0) out.push(i);
        }
        return out;
    }

    function openPage(i) {
        console.log("[settings] openPage", i, pages[(i + pages.length) % pages.length].source)
        currentIdx = (i + pages.length) % pages.length;
        NxNav.reset(pages[currentIdx].label, pages[currentIdx].source);
    }

    visible: true
    title: "Hydro Settings"
    onClosing: Qt.quit()
    minimumWidth: 900
    minimumHeight: 560
    width: 1240
    height: 780
    color: Appearance.m3colors.m3surfaceContainerLow

    Component.onCompleted: {
        MaterialThemeLoader.reapplyTheme()
        Config.readWriteDelay = 0 // settings app sets one value at a time
        openPage(0)
    }

    Timer {
        interval: 250
        running: true
        onTriggered: Quickshell.execDetached(["sh", "-c", "command -v hyprctl >/dev/null 2>&1 && hyprctl --batch 'dispatch setfloating ; dispatch centerwindow'"])
    }

    NxFilePicker {
        id: filePicker
        anchors.fill: parent
        property string tag: ""
        onAccepted: path => NxNav.filePicked(tag, path)
    }
    Connections {
        target: NxNav
        function onPickFile(tag, title) { filePicker.tag = tag; filePicker.title = title; filePicker.open("") }
    }

    Shortcut { sequence: "Ctrl+K"; onActivated: { searchInput.forceActiveFocus(); searchInput.selectAll() } }
    Shortcut { sequence: "Ctrl+F"; onActivated: { searchInput.forceActiveFocus(); searchInput.selectAll() } }
    Shortcut { sequence: "Alt+Left"; onActivated: NxNav.pop() }
    Shortcut { sequence: "Ctrl+PgDown"; onActivated: root.openPage(root.currentIdx + 1) }
    Shortcut { sequence: "Ctrl+PgUp"; onActivated: root.openPage(root.currentIdx - 1) }
    Shortcut {
        sequence: "Escape"
        onActivated: searchInput.text !== "" ? searchInput.text = "" : NxNav.isSubPage ? NxNav.pop() : root.close()
    }

    component NavItem: Rectangle {
        id: item
        property bool current: false
        property bool first: false
        property bool last: false
        property string icon
        property string label
        property string desc
        property bool noFill: false
        signal tapped()
        Layout.fillWidth: true
        implicitHeight: 64
        color: current ? Appearance.colors.colSecondaryContainer : Appearance.colors.colSurfaceContainerHigh
        readonly property real big: 28
        readonly property real small: 4
        topLeftRadius: ma.pressed ? 12 : current ? 32 : first ? big : small
        topRightRadius: topLeftRadius
        bottomLeftRadius: ma.pressed ? 12 : current ? 32 : last ? big : small
        bottomRightRadius: bottomLeftRadius
        Behavior on topLeftRadius { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }
        Behavior on bottomLeftRadius { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: 200 } }
        Rectangle {
            anchors.fill: parent
            topLeftRadius: item.topLeftRadius; topRightRadius: item.topRightRadius
            bottomLeftRadius: item.bottomLeftRadius; bottomRightRadius: item.bottomRightRadius
            color: Appearance.m3colors.m3onSurface
            opacity: ma.containsMouse ? 0.07 : 0
            Behavior on opacity { NumberAnimation { duration: 120 } }
        }
        MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: { console.log("[settings] nav click", item.label); item.tapped() } }
        RowLayout {
            anchors { fill: parent; leftMargin: 14; rightMargin: 14 }
            spacing: 14
            Rectangle {
                implicitWidth: 40; implicitHeight: 40
                radius: 20
                color: item.current ? Appearance.colors.colPrimary : Appearance.colors.colSecondaryContainer
                Behavior on color { ColorAnimation { duration: 200 } }
                MaterialSymbol {
                    anchors.centerIn: parent
                    text: item.icon
                    fill: item.noFill ? 0 : 1
                    iconSize: 22
                    color: item.current ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSecondaryContainer
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                StyledText { Layout.fillWidth: true; text: item.label; elide: Text.ElideRight; font.pixelSize: Appearance.font.pixelSize.normal; color: Appearance.m3colors.m3onSurface }
                StyledText { Layout.fillWidth: true; text: item.desc; elide: Text.ElideRight; font.pixelSize: Appearance.font.pixelSize.smaller; color: Appearance.m3colors.m3onSurfaceVariant }
            }
        }
    }

    Item {
        id: frame
        anchors { fill: parent; margins: 16 }

        ColumnLayout {
            id: navPane
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
            width: Math.min(360, Math.round(root.width / 3.3))
            spacing: 14

            Rectangle {
                id: profileCard
                Layout.fillWidth: true
                implicitHeight: 72
                radius: 28
                color: Appearance.m3colors.m3surfaceContainer
                readonly property int profileIdx: root.pages.findIndex(p => p.source.indexOf("ProfilePage") >= 0)
                Rectangle { anchors.fill: parent; radius: parent.radius; color: Appearance.m3colors.m3onSurface; opacity: pcMa.containsMouse ? 0.07 : 0; Behavior on opacity { NumberAnimation { duration: 120 } } }
                MouseArea { id: pcMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.openPage(profileCard.profileIdx) }
                RowLayout {
                    anchors { fill: parent; leftMargin: 14; rightMargin: 18 }
                    spacing: 14
                    ProfileAvatar { size: 48; Layout.alignment: Qt.AlignVCenter }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        StyledText { Layout.fillWidth: true; text: SystemInfo.username; elide: Text.ElideRight; font.pixelSize: Appearance.font.pixelSize.larger; font.weight: Font.Medium; color: Appearance.m3colors.m3onSurface }
                        StyledText { Layout.fillWidth: true; text: Translation.tr("Change profile picture"); elide: Text.ElideRight; font.pixelSize: 12; color: Appearance.m3colors.m3outline }
                    }
                    MaterialSymbol { text: "chevron_right"; iconSize: 22; color: Appearance.m3colors.m3onSurfaceVariant }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 54
                radius: 27
                color: Appearance.m3colors.m3surfaceContainerLowest
                border.width: searchInput.activeFocus ? 2 : 1
                border.color: searchInput.activeFocus ? Appearance.colors.colPrimary : Appearance.m3colors.m3outlineVariant
                Behavior on border.color { ColorAnimation { duration: 150 } }
                RowLayout {
                    anchors { fill: parent; leftMargin: 18; rightMargin: 12 }
                    spacing: 10
                    MaterialSymbol { text: "search"; iconSize: 24; color: Appearance.m3colors.m3onSurfaceVariant }
                    TextInput {
                        id: searchInput
                        Layout.fillWidth: true
                        verticalAlignment: TextInput.AlignVCenter
                        selectByMouse: true
                        clip: true
                        color: Appearance.m3colors.m3onSurface
                        font.pixelSize: Appearance.font.pixelSize.normal
                        onAccepted: if (root.results.length > 0) { root.openPage(root.results[0]); text = "" }
                        StyledText {
                            visible: searchInput.text.length === 0
                            anchors.verticalCenter: parent.verticalCenter
                            text: Translation.tr("Search settings")
                            color: Appearance.m3colors.m3outline
                            font.pixelSize: Appearance.font.pixelSize.normal
                        }
                    }
                    MaterialSymbol {
                        visible: searchInput.text.length > 0
                        text: "close"; iconSize: 22; color: Appearance.m3colors.m3onSurfaceVariant
                        MouseArea { anchors { fill: parent; margins: -6 } cursorShape: Qt.PointingHandCursor; onClicked: searchInput.text = "" }
                    }
                }
            }

            StyledFlickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                contentHeight: navCol.implicitHeight + 8
                contentWidth: width

                ColumnLayout {
                    id: navCol
                    width: parent.width
                    spacing: 4

                    Repeater {
                        model: root.searching ? [] : root.pages
                        NavItem {
                            required property var modelData
                            required property int index
                            readonly property bool catStart: index === 0 || root.pages[index - 1].cat !== modelData.cat
                            readonly property bool catEnd: index === root.pages.length - 1 || root.pages[index + 1].cat !== modelData.cat
                            Layout.topMargin: index !== 0 && catStart ? 10 : 0
                            current: root.currentIdx === index
                            first: catStart
                            last: catEnd
                            icon: modelData.icon; label: modelData.label; desc: modelData.desc; noFill: modelData.noFill ?? false
                            onTapped: root.openPage(index)
                        }
                    }
                    Repeater {
                        model: root.searching ? root.results : []
                        NavItem {
                            required property int modelData
                            required property int index
                            readonly property var p: root.pages[modelData]
                            current: root.currentIdx === modelData
                            first: index === 0
                            last: index === root.results.length - 1
                            icon: p.icon; label: p.label; desc: root.catNames[p.cat] + " · " + p.desc; noFill: p.noFill ?? false
                            onTapped: { root.openPage(modelData); searchInput.text = "" }
                        }
                    }
                    StyledText {
                        visible: root.searching && root.results.length === 0
                        Layout.fillWidth: true
                        Layout.topMargin: 20
                        horizontalAlignment: Text.AlignHCenter
                        text: Translation.tr("No settings match")
                        color: Appearance.m3colors.m3outline
                    }
                }
            }
        }

        Rectangle {
            id: pagePanel
            anchors { left: navPane.right; leftMargin: 16; right: parent.right; top: parent.top; bottom: parent.bottom }
            radius: 16
            color: Appearance.m3colors.m3surface
            clip: true

            Item {
                anchors { fill: parent; margins: 28 }

                RowLayout {
                    id: pageHeader
                    anchors { left: parent.left; right: parent.right; top: parent.top }
                    spacing: 14
                    Rectangle {
                        visible: NxNav.isSubPage
                        implicitWidth: 44; implicitHeight: 44
                        radius: 22
                        color: Appearance.colors.colSurfaceContainerHigh
                        Behavior on radius { NumberAnimation { duration: 150 } }
                        MaterialSymbol { anchors.centerIn: parent; text: "arrow_back"; iconSize: 24; color: Appearance.m3colors.m3onSurfaceVariant }
                        MouseArea { id: backMa; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: NxNav.pop() }
                    }
                    StyledText {
                        Layout.fillWidth: true
                        text: NxNav.current ? NxNav.current.title : ""
                        elide: Text.ElideRight
                        font.pixelSize: 29
                        font.weight: Font.Medium
                        color: Appearance.m3colors.m3onSurface
                    }
                }

                Item {
                    anchors { left: parent.left; right: parent.right; top: pageHeader.bottom; topMargin: 20; bottom: parent.bottom }
                    clip: true

                    Loader {
                        id: pageLoader
                        anchors.fill: parent
                        active: Config.ready
                        property string shownSource: ""
                        source: shownSource
                        transform: Translate { id: pageSlide }

                        Connections {
                            target: NxNav
                            function onStackChanged() { switchAnim.complete(); switchAnim.start() }
                        }
                        SequentialAnimation {
                            id: switchAnim
                            ParallelAnimation {
                                NumberAnimation { target: pageLoader; property: "opacity"; to: 0; duration: 90 }
                                NumberAnimation { target: pageSlide; property: "x"; to: -28; duration: 90; easing.type: Easing.InCubic }
                            }
                            ScriptAction { script: { pageLoader.shownSource = NxNav.current ? NxNav.current.source : ""; pageSlide.x = 40 } }
                            ParallelAnimation {
                                NumberAnimation { target: pageLoader; property: "opacity"; to: 1; duration: 300 }
                                NumberAnimation { target: pageSlide; property: "x"; to: 0; duration: 480; easing.type: Easing.BezierSpline; easing.bezierCurve: [0.38, 1.21, 0.22, 1.00, 1, 1] }
                            }
                        }
                        onLoaded: probe.restart()
                        Timer {
                            id: probe
                            interval: 700
                            onTriggered: console.log("[settings] probe: loader", pageLoader.width + "x" + pageLoader.height,
                                "item", pageLoader.item ? pageLoader.item.width + "x" + pageLoader.item.height : "none",
                                "opacity", pageLoader.opacity, "slideX", pageSlide.x, "window", root.width + "x" + root.height)
                        }
                    }
                }
            }
        }
    }
}
