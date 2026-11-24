
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions as CF

ApplicationWindow {
    id: root

    readonly property var pages: [
        { group: "shell",  name: Translation.tr("Quick"),      sub: Translation.tr("Wallpaper, colors, bar, screen"),  icon: "tune",             shape: MaterialShape.Shape.Cookie9Sided, keywords: "toggles sliders sidebar dashboard wallpaper", component: "modules/settings/QuickConfig.qml" },
        { group: "shell",  name: Translation.tr("General"),    sub: Translation.tr("Audio, battery, language, time"),  icon: "settings",         shape: MaterialShape.Shape.Clover4Leaf,  keywords: "audio battery language sounds time", component: "modules/settings/GeneralConfig.qml" },
        { group: "shell",  name: Translation.tr("Bar"),        sub: Translation.tr("Layout, style, widgets"),          icon: "dock_to_bottom",   shape: MaterialShape.Shape.Pill,         keywords: "layout pills widgets workspaces tray clock position float", component: "modules/settings/hydro/HBarTab.qml" },
        { group: "look",   name: Translation.tr("Appearance"), sub: Translation.tr("Theme, palette, fonts, rounding"), icon: "palette",          shape: MaterialShape.Shape.Flower,       keywords: "theme colors palette wallpaper rounding font", component: "modules/settings/hydro/HAppearanceTab.qml" },
        { group: "look",   name: Translation.tr("Background"), sub: Translation.tr("Parallax, clock, widgets"),        icon: "wallpaper",        shape: MaterialShape.Shape.Sunny,        keywords: "wallpaper clock parallax widgets", component: "modules/settings/BackgroundConfig.qml" },
        { group: "look",   name: Translation.tr("Interface"),  sub: Translation.tr("Dock, lock screen, corners"),      icon: "web_asset",        shape: MaterialShape.Shape.SoftBurst,    keywords: "dock lock screen corners overview ui", component: "modules/settings/InterfaceConfig.qml" },
        { group: "system", name: Translation.tr("Services"),   sub: Translation.tr("Search, weather, network"),    icon: "cloud",            shape: MaterialShape.Shape.Gem,          keywords: "ai search weather network resources", component: "modules/settings/ServicesConfig.qml" },
        { group: "system", name: Translation.tr("Advanced"),   sub: Translation.tr("Color generation, Hyprland"),      icon: "code",             shape: MaterialShape.Shape.Pentagon,     keywords: "color generation hyprland config", component: "modules/settings/AdvancedConfig.qml" },
        { group: "hydro",  name: Translation.tr("About"),      sub: Translation.tr("Version, credits, license"),       icon: "info",             shape: MaterialShape.Shape.Cookie6Sided, keywords: "version credits license", component: "modules/settings/hydro/HAboutTab.qml" }
    ]
    readonly property var groupTitles: ({ shell: Translation.tr("Shell"), look: Translation.tr("Look"), system: Translation.tr("System"), hydro: Translation.tr("Hydro") })

    property int currentPage: 0
    property bool pageOpen: false
    property string query: ""
    property bool justCopied: false
    readonly property string configPath: CF.FileUtils.trimFileProtocol(`${Directories.config}/hydro/config.json`)

    function matches(i) {
        const q = query.trim().toLowerCase();
        if (q === "") return true;
        const p = pages[i];
        return (p.name + " " + p.group + " " + p.sub + " " + p.keywords).toLowerCase().indexOf(q) >= 0;
    }
    function groupOf(i) { return pages[i].group }
    function isFirstInGroup(i) {
        for (let j = 0; j < i; j++) if (groupOf(j) === groupOf(i) && matches(j)) return false;
        return true;
    }
    function isLastInGroup(i) {
        for (let j = i + 1; j < pages.length; j++) if (groupOf(j) === groupOf(i) && matches(j)) return false;
        return true;
    }
    function groupHasMatch(g) {
        for (let j = 0; j < pages.length; j++) if (groupOf(j) === g && matches(j)) return true;
        return false;
    }
    function openPage(i) {
        currentPage = (i + pages.length) % pages.length;
        pageLoader.source = pages[currentPage].component;
        pageOpen = true;
    }
    function closePage() { pageOpen = false }

    visible: true
    title: "Hydro Settings"
    onClosing: Qt.quit()
    minimumWidth: 800
    minimumHeight: 520
    width: 1040
    height: 720
    color: Appearance.m3colors.m3background

    Component.onCompleted: {
        MaterialThemeLoader.reapplyTheme()
        Config.readWriteDelay = 0 // settings app sets one value at a time
    }

    Shortcut { sequence: "Ctrl+PgDown"; enabled: root.pageOpen; onActivated: root.openPage(root.currentPage + 1) }
    Shortcut { sequence: "Ctrl+PgUp";   enabled: root.pageOpen; onActivated: root.openPage(root.currentPage - 1) }
    Shortcut { sequence: "Alt+Left";    enabled: root.pageOpen; onActivated: root.closePage() }
    Shortcut { sequence: "Ctrl+K";      onActivated: { root.closePage(); searchInput.forceActiveFocus(); searchInput.selectAll() } }
    Shortcut { sequence: "Escape";      onActivated: root.pageOpen ? root.closePage() : root.close() }

    readonly property var spatial: Appearance.animationCurves.expressiveDefaultSpatial
    component SpatialX: NumberAnimation { duration: 500; easing.type: Easing.BezierSpline; easing.bezierCurve: root.spatial }

    Item {
        id: home
        width: parent.width
        height: parent.height
        x: root.pageOpen ? -width * 0.18 : 0
        opacity: root.pageOpen ? 0 : 1
        visible: opacity > 0
        scale: root.pageOpen ? 0.96 : 1
        Behavior on x { SpatialX {} }
        Behavior on scale { SpatialX {} }
        Behavior on opacity { NumberAnimation { duration: 220 } }

        StyledFlickable {
            id: homeFlick
            anchors.fill: parent
            contentHeight: homeCol.implicitHeight + 80
            clip: true

            ColumnLayout {
                id: homeCol
                width: Math.min(720, home.width - 48)
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6

                StyledText {
                    Layout.topMargin: 44
                    Layout.leftMargin: 8
                    text: "Settings"
                    color: Appearance.colors.colOnLayer0
                    font.family: Appearance.font.family.expressive
                    font.pixelSize: 56
                    font.weight: Font.DemiBold
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.topMargin: 14
                    Layout.bottomMargin: 10
                    implicitHeight: 56
                    radius: height / 2
                    color: searchInput.activeFocus ? Appearance.colors.colLayer2 : Appearance.colors.colLayer1
                    Behavior on color { ColorAnimation { duration: 160 } }

                    MaterialSymbol {
                        id: searchIcon
                        anchors { left: parent.left; leftMargin: 20; verticalCenter: parent.verticalCenter }
                        text: "search"
                        iconSize: 24
                        color: Appearance.colors.colOnLayer1
                    }
                    TextInput {
                        id: searchInput
                        anchors { left: searchIcon.right; leftMargin: 14; right: clearBtn.left; verticalCenter: parent.verticalCenter }
                        color: Appearance.colors.colOnLayer1
                        font.family: Appearance.font.family.main
                        font.pixelSize: Appearance.font.pixelSize.larger
                        selectByMouse: true
                        clip: true
                        onTextChanged: root.query = text
                        onAccepted: {
                            for (let i = 0; i < root.pages.length; i++) if (root.matches(i)) { root.openPage(i); break }
                        }
                        StyledText {
                            visible: searchInput.text.length === 0
                            text: Translation.tr("Search settings")
                            color: Appearance.colors.colSubtext
                            font.pixelSize: Appearance.font.pixelSize.larger
                        }
                    }
                    Item {
                        id: clearBtn
                        anchors { right: parent.right; rightMargin: 12; verticalCenter: parent.verticalCenter }
                        width: 36; height: 36
                        opacity: searchInput.text.length > 0 ? 1 : 0
                        scale: searchInput.text.length > 0 ? 1 : 0.6
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                        Behavior on scale { SpatialX {} }
                        MaterialSymbol { anchors.centerIn: parent; text: "close"; iconSize: 20; color: Appearance.colors.colOnLayer1 }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: searchInput.text = "" }
                    }
                }

                Item {
                    id: hero
                    Layout.fillWidth: true
                    Layout.bottomMargin: 14
                    implicitHeight: 190
                    visible: root.query.trim() === ""
                    readonly property string path: Config.options.background.wallpaperPath
                    scale: heroArea.pressed ? 0.985 : 1
                    Behavior on scale { SpatialX {} }

                    StyledImage {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        source: hero.path.length > 0 ? hero.path : Qt.resolvedUrl(Directories.assetsPath + "/images/default_wallpaper.png")
                        cache: false
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle { width: hero.width; height: hero.height; radius: 36 }
                        }
                    }
                    Rectangle { // legibility scrim
                        anchors.fill: parent
                        radius: 36
                        gradient: Gradient {
                            GradientStop { position: 0.45; color: "transparent" }
                            GradientStop { position: 1.0; color: "#99000000" }
                        }
                    }
                    Row {
                        anchors { left: parent.left; bottom: parent.bottom; margins: 22 }
                        spacing: 12
                        MaterialShapeWrappedMaterialSymbol {
                            shape: MaterialShape.Shape.Cookie12Sided
                            text: "wallpaper"
                            iconSize: 22
                            padding: 11
                            color: Appearance.colors.colPrimaryContainer
                            colSymbol: Appearance.colors.colOnPrimaryContainer
                        }
                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            StyledText { text: Translation.tr("Wallpaper & colors"); color: "white"; font.pixelSize: Appearance.font.pixelSize.larger; font.weight: Font.DemiBold }
                            StyledText { text: hero.path.length > 0 ? hero.path.split("/").pop() : Translation.tr("Default wallpaper"); color: "#D0FFFFFF"; font.pixelSize: Appearance.font.pixelSize.smaller }
                        }
                    }
                    MouseArea { id: heroArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.openPage(0) }
                }

                Repeater {
                    model: root.pages

                    ColumnLayout {
                        id: wrap
                        required property int index
                        required property var modelData
                        Layout.fillWidth: true
                        spacing: 0
                        visible: root.matches(index)

                        readonly property bool first: root.isFirstInGroup(index)
                        readonly property bool last: root.isLastInGroup(index)

                        StyledText {
                            visible: wrap.first
                            Layout.topMargin: 16
                            Layout.bottomMargin: 8
                            Layout.leftMargin: 14
                            text: root.groupTitles[wrap.modelData.group]
                            color: Appearance.colors.colPrimary
                            font.pixelSize: Appearance.font.pixelSize.normal
                            font.weight: Font.DemiBold
                        }

                        Item {
                            id: row
                            Layout.fillWidth: true
                            Layout.topMargin: wrap.first ? 0 : 3
                            implicitHeight: 76

                            readonly property real big: 30
                            readonly property real small: 8
                            Rectangle {
                                anchors.fill: parent
                                topLeftRadius: rowArea.pressed ? 22 : (wrap.first ? row.big : row.small)
                                topRightRadius: topLeftRadius
                                bottomLeftRadius: rowArea.pressed ? 22 : (wrap.last ? row.big : row.small)
                                bottomRightRadius: bottomLeftRadius
                                color: rowArea.containsMouse ? Appearance.colors.colLayer1Hover : Appearance.colors.colLayer1
                                Behavior on color { ColorAnimation { duration: 140 } }
                                Behavior on topLeftRadius { NumberAnimation { duration: 300; easing.type: Easing.BezierSpline; easing.bezierCurve: Appearance.animationCurves.expressiveFastSpatial } }
                                Behavior on bottomLeftRadius { NumberAnimation { duration: 300; easing.type: Easing.BezierSpline; easing.bezierCurve: Appearance.animationCurves.expressiveFastSpatial } }
                            }

                            MaterialShapeWrappedMaterialSymbol {
                                id: badge
                                anchors { left: parent.left; leftMargin: 16; verticalCenter: parent.verticalCenter }
                                shape: wrap.modelData.shape
                                text: wrap.modelData.icon
                                iconSize: 24
                                padding: 12
                                color: wrap.modelData.group === "shell" ? Appearance.colors.colPrimaryContainer
                                     : wrap.modelData.group === "look" ? Appearance.colors.colTertiaryContainer
                                     : Appearance.colors.colSecondaryContainer
                                colSymbol: wrap.modelData.group === "shell" ? Appearance.colors.colOnPrimaryContainer
                                         : wrap.modelData.group === "look" ? Appearance.colors.colOnTertiaryContainer
                                         : Appearance.colors.colOnSecondaryContainer
                                rotation: rowArea.containsMouse ? 12 : 0
                                Behavior on rotation { SpatialX {} }
                            }
                            Column {
                                anchors { left: badge.right; leftMargin: 16; right: chevron.left; rightMargin: 8; verticalCenter: parent.verticalCenter }
                                spacing: 2
                                StyledText { width: parent.width; elide: Text.ElideRight; text: wrap.modelData.name; color: Appearance.colors.colOnLayer1; font.pixelSize: Appearance.font.pixelSize.larger; font.weight: Font.Medium }
                                StyledText { width: parent.width; elide: Text.ElideRight; text: wrap.modelData.sub; color: Appearance.colors.colSubtext; font.pixelSize: Appearance.font.pixelSize.smaller }
                            }
                            MaterialSymbol {
                                id: chevron
                                anchors { right: parent.right; rightMargin: rowArea.containsMouse ? 16 : 20; verticalCenter: parent.verticalCenter }
                                Behavior on anchors.rightMargin { NumberAnimation { duration: 200 } }
                                text: "chevron_right"
                                iconSize: 24
                                color: Appearance.colors.colSubtext
                            }
                            MouseArea {
                                id: rowArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.openPage(wrap.index)
                            }
                        }
                    }
                }

                StyledText {
                    visible: root.query.trim() !== "" && !root.pages.some((p, i) => root.matches(i))
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 40
                    text: Translation.tr("Nothing found")
                    color: Appearance.colors.colSubtext
                    font.pixelSize: Appearance.font.pixelSize.larger
                }

                RowLayout {
                    Layout.topMargin: 26
                    Layout.alignment: Qt.AlignHCenter
                    visible: root.query.trim() === ""
                    spacing: 10
                    ExpressiveButton {
                        icon: "data_object"
                        label: root.justCopied ? Translation.tr("Path copied") : Translation.tr("Open config.json")
                        onClicked: Qt.openUrlExternally(root.configPath)
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.RightButton
                            onClicked: {
                                Quickshell.clipboardText = root.configPath
                                root.justCopied = true
                                copiedTimer.restart()
                            }
                        }
                        Timer { id: copiedTimer; interval: 1500; onTriggered: root.justCopied = false }
                    }
                }
            }
        }
    }

    Item {
        id: pageLayer
        width: parent.width
        height: parent.height
        x: root.pageOpen ? 0 : width * 0.3
        opacity: root.pageOpen ? 1 : 0
        visible: opacity > 0
        Behavior on x { SpatialX {} }
        Behavior on opacity { NumberAnimation { duration: 220 } }

        Item {
            id: appBar
            anchors { left: parent.left; right: parent.right; top: parent.top }
            height: 96

            Item {
                id: backBtn
                anchors { left: parent.left; leftMargin: 28; verticalCenter: parent.verticalCenter }
                width: 52; height: 52
                scale: backArea.pressed ? 0.9 : 1
                Behavior on scale { SpatialX {} }
                Rectangle {
                    anchors.fill: parent
                    radius: backArea.pressed ? 14 : 26
                    color: backArea.containsMouse ? Appearance.colors.colLayer2Hover : Appearance.colors.colLayer2
                    Behavior on radius { NumberAnimation { duration: 300; easing.type: Easing.BezierSpline; easing.bezierCurve: Appearance.animationCurves.expressiveFastSpatial } }
                    Behavior on color { ColorAnimation { duration: 140 } }
                }
                MaterialSymbol { anchors.centerIn: parent; text: "arrow_back"; iconSize: 24; color: Appearance.colors.colOnLayer2 }
                MouseArea { id: backArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.closePage() }
            }

            MaterialShapeWrappedMaterialSymbol {
                id: titleBadge
                anchors { left: backBtn.right; leftMargin: 18; verticalCenter: parent.verticalCenter }
                shape: root.pages[root.currentPage].shape
                text: root.pages[root.currentPage].icon
                iconSize: 22
                padding: 10
                color: Appearance.colors.colPrimaryContainer
                colSymbol: Appearance.colors.colOnPrimaryContainer
            }
            StyledText {
                anchors { left: titleBadge.right; leftMargin: 14; verticalCenter: parent.verticalCenter }
                text: root.pages[root.currentPage].name
                color: Appearance.colors.colOnLayer0
                font.family: Appearance.font.family.expressive
                font.pixelSize: 34
                font.weight: Font.DemiBold
            }
            StyledText {
                anchors { right: parent.right; rightMargin: 32; verticalCenter: parent.verticalCenter }
                text: `${root.currentPage + 1} / ${root.pages.length}`
                color: Appearance.colors.colSubtext
                font.pixelSize: Appearance.font.pixelSize.smaller
            }
        }

        Item {
            anchors { left: parent.left; right: parent.right; top: appBar.bottom; bottom: parent.bottom }
            clip: true
            Loader {
                id: pageLoader
                anchors.fill: parent
                active: Config.ready
                source: root.pages[0].component
            }
        }
    }
}
