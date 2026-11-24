import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Qt5Compat.GraphicalEffects
import Quickshell
import qs.modules.common
import qs.modules.common.models
import qs.modules.common.widgets

Item {
    id: root
    property string title: root.tr("Choose a picture")
    property string selected: ""
    property bool shown: false
    readonly property string home: Quickshell.env("HOME")
    signal accepted(string path)
    function tr(s) { const r = Translation.tr(s); return (r && r.length > 0) ? r : s }

    function open(startPath) {
        selected = "";
        fm.folder = "file://" + (startPath && startPath.length > 0 ? startPath : home + "/Pictures");
        shown = true;
        card.forceActiveFocus();
    }
    function close() { shown = false }
    function accept() { if (selected.length > 0) { const p = selected; shown = false; accepted(p) } }

    z: 200
    visible: opacity > 0.01
    opacity: shown ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 180 } }

    Shortcut { enabled: root.shown; sequence: "Escape"; onActivated: root.close() }
    Shortcut { enabled: root.shown; sequence: "Return"; onActivated: root.accept() }
    Shortcut { enabled: root.shown; sequence: "Backspace"; onActivated: fm.navigateUp() }

    Rectangle { anchors.fill: parent; color: "#000000"; opacity: 0.5; MouseArea { anchors.fill: parent; onClicked: root.close() } }

    FolderListModelWithHistory {
        id: fm
        folder: "file://" + root.home
        showDirs: true
        showFiles: true
        showDotAndDotDot: false
        showHidden: false
        showDirsFirst: true
        sortField: FolderListModel.Name
        nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp", "*.gif", "*.bmp", "*.svg", "*.PNG", "*.JPG", "*.JPEG", "*.WEBP"]
    }

    component RoundBtn: Rectangle {
        property string glyph
        property bool dim: false
        signal tapped()
        implicitWidth: 44; implicitHeight: 44
        radius: ma.pressed ? 12 : 22
        color: Appearance.colors.colSecondaryContainer
        opacity: dim ? 0.4 : 1
        Behavior on radius { NumberAnimation { duration: 150 } }
        MaterialSymbol { anchors.centerIn: parent; text: parent.glyph; iconSize: 22; color: Appearance.colors.colOnSecondaryContainer }
        MouseArea { id: ma; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: parent.tapped() }
    }

    Rectangle {
        id: card
        anchors.centerIn: parent
        width: Math.min(parent.width - 48, 900)
        height: Math.min(parent.height - 48, 620)
        radius: 28
        color: Appearance.m3colors.m3surfaceContainerHigh
        scale: root.shown ? 1 : 0.94
        Behavior on scale { NumberAnimation { duration: 380; easing.type: Easing.BezierSpline; easing.bezierCurve: [0.38, 1.21, 0.22, 1.00, 1, 1] } }
        MouseArea { anchors.fill: parent } // keep clicks inside the card

        ColumnLayout {
            anchors { fill: parent; margins: 22 }
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                StyledText { Layout.fillWidth: true; text: root.title; font.pixelSize: 24; font.weight: Font.Medium; color: Appearance.m3colors.m3onSurface }
                RoundBtn { glyph: "close"; onTapped: root.close() }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                RoundBtn { glyph: "arrow_back"; dim: fm.currentFolderHistoryIndex <= 0; onTapped: fm.navigateBack() }
                RoundBtn { glyph: "arrow_upward"; onTapped: fm.navigateUp() }
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 44
                    radius: 22
                    color: Appearance.m3colors.m3surfaceContainerLowest
                    StyledText {
                        anchors { fill: parent; leftMargin: 18; rightMargin: 18 }
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideLeft
                        text: decodeURIComponent(fm.folder.toString().replace("file://", ""))
                        font.family: Appearance.font.family.monospace
                        font.pixelSize: Appearance.font.pixelSize.small
                        color: Appearance.m3colors.m3onSurfaceVariant
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 14

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 168
                    Column {
                        anchors { left: parent.left; right: parent.right; top: parent.top }
                        spacing: 4
                        Repeater {
                            model: [
                                { i: "home", l: root.tr("Home"), p: "" },
                                { i: "image", l: root.tr("Pictures"), p: "/Pictures" },
                                { i: "download", l: root.tr("Downloads"), p: "/Downloads" },
                                { i: "description", l: root.tr("Documents"), p: "/Documents" },
                                { i: "desktop_windows", l: root.tr("Desktop"), p: "/Desktop" }
                            ]
                            Rectangle {
                                id: place
                                required property var modelData
                                readonly property string dest: "file://" + root.home + modelData.p
                                readonly property bool here: fm.folder.toString() === dest
                                width: parent.width
                                height: 48
                                radius: here ? 24 : 12
                                color: here ? Appearance.colors.colSecondaryContainer : "transparent"
                                Behavior on radius { NumberAnimation { duration: 200 } }
                                Rectangle { anchors.fill: parent; radius: parent.radius; color: Appearance.m3colors.m3onSurface; opacity: pma.containsMouse && !place.here ? 0.07 : 0 }
                                MaterialSymbol {
                                    id: pIcon
                                    anchors { left: parent.left; leftMargin: 14; verticalCenter: parent.verticalCenter }
                                    text: place.modelData.i; iconSize: 22; fill: place.here ? 1 : 0
                                    color: place.here ? Appearance.colors.colOnSecondaryContainer : Appearance.m3colors.m3onSurfaceVariant
                                }
                                StyledText {
                                    anchors { left: pIcon.right; leftMargin: 12; right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
                                    elide: Text.ElideRight
                                    text: place.modelData.l
                                    color: place.here ? Appearance.colors.colOnSecondaryContainer : Appearance.m3colors.m3onSurface
                                }
                                MouseArea { id: pma; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: fm.folder = place.dest }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 20
                    color: Appearance.m3colors.m3surface
                    clip: true

                    GridView {
                        id: grid
                        anchors { fill: parent; margins: 10 }
                        clip: true
                        readonly property int perRow: Math.max(1, Math.floor(width / 132))
                        cellWidth: Math.floor(width / perRow)
                        cellHeight: 138
                        model: fm
                        boundsBehavior: Flickable.StopAtBounds

                        delegate: Item {
                            id: cell
                            required property string fileName
                            required property string filePath
                            required property bool fileIsDir
                            readonly property bool sel: !fileIsDir && root.selected === filePath
                            width: grid.cellWidth
                            height: grid.cellHeight

                            Rectangle {
                                id: tile
                                anchors { fill: parent; margins: 5 }
                                radius: cell.sel ? 14 : 20
                                color: cell.sel ? Appearance.colors.colPrimaryContainer : Appearance.m3colors.m3surfaceContainer
                                Behavior on radius { NumberAnimation { duration: 180 } }
                                Rectangle { anchors.fill: parent; radius: parent.radius; color: Appearance.m3colors.m3onSurface; opacity: cma.containsMouse && !cell.sel ? 0.07 : 0 }

                                MaterialSymbol {
                                    visible: cell.fileIsDir
                                    anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 22 }
                                    text: "folder"; fill: 1; iconSize: 52
                                    color: Appearance.colors.colPrimary
                                }
                                Item {
                                    id: thumb
                                    visible: !cell.fileIsDir
                                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 6; bottom: lbl.top; bottomMargin: 4 }
                                    Image {
                                        anchors.fill: parent
                                        source: cell.fileIsDir ? "" : "file://" + cell.filePath
                                        sourceSize: Qt.size(240, 240)
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                        cache: false
                                        layer.enabled: true
                                        layer.effect: OpacityMask { maskSource: Rectangle { width: thumb.width; height: thumb.height; radius: 14 } }
                                    }
                                }
                                StyledText {
                                    id: lbl
                                    anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 8; bottomMargin: 6 }
                                    height: 18
                                    horizontalAlignment: Text.AlignHCenter
                                    elide: Text.ElideMiddle
                                    text: cell.fileName
                                    font.pixelSize: 12
                                    color: cell.sel ? Appearance.colors.colOnPrimaryContainer : Appearance.m3colors.m3onSurface
                                }
                                MouseArea {
                                    id: cma
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: cell.fileIsDir ? fm.folder = "file://" + cell.filePath : root.selected = cell.filePath
                                    onDoubleClicked: if (!cell.fileIsDir) { root.selected = cell.filePath; root.accept() }
                                }
                            }
                        }
                    }
                    StyledText {
                        visible: grid.count === 0
                        anchors.centerIn: parent
                        text: root.tr("No pictures in this folder")
                        color: Appearance.m3colors.m3outline
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                StyledText {
                    Layout.fillWidth: true
                    elide: Text.ElideMiddle
                    text: root.selected.length > 0 ? root.selected.split("/").pop() : root.tr("Pick a picture")
                    color: Appearance.m3colors.m3onSurfaceVariant
                }
                Rectangle {
                    implicitWidth: cancelT.implicitWidth + 40; implicitHeight: 44; radius: 22
                    color: Appearance.colors.colSecondaryContainer
                    StyledText { id: cancelT; anchors.centerIn: parent; text: root.tr("Cancel"); color: Appearance.colors.colOnSecondaryContainer }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.close() }
                }
                Rectangle {
                    implicitWidth: okT.implicitWidth + 40; implicitHeight: 44; radius: 22
                    color: Appearance.colors.colPrimary
                    opacity: root.selected.length > 0 ? 1 : 0.4
                    StyledText { id: okT; anchors.centerIn: parent; text: root.tr("Select"); color: Appearance.colors.colOnPrimary }
                    MouseArea { anchors.fill: parent; enabled: root.selected.length > 0; cursorShape: Qt.PointingHandCursor; onClicked: root.accept() }
                }
            }
        }
    }
}
