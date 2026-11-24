pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Qt5Compat.GraphicalEffects
import Quickshell
import qs.modules.common.models as HM
import qs.modules.nexus.compat
import qs.modules.nexus.components

Item {
    id: root

    property string title: Tr.tr("Choose a picture")
    property string selected
    property bool shown
    readonly property string home: Quickshell.env("HOME")

    signal accepted(string path)

    function open(startPath: string): void {
        selected = "";
        fm.folder = "file://" + (startPath && startPath.length > 0 ? startPath : home + "/Pictures");
        shown = true;
    }
    function close(): void {
        shown = false;
    }
    function accept(): void {
        if (selected.length > 0) {
            const p = selected;
            shown = false;
            accepted(p);
        }
    }

    z: 200
    visible: opacity > 0.01
    opacity: shown ? 1 : 0

    Behavior on opacity {
        Anim {}
    }

    Shortcut {
        enabled: root.shown
        sequence: "Escape"
        onActivated: root.close()
    }
    Shortcut {
        enabled: root.shown
        sequence: "Return"
        onActivated: root.accept()
    }
    Shortcut {
        enabled: root.shown
        sequence: "Backspace"
        onActivated: fm.navigateUp()
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.5

        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }
    }

    HM.FolderListModelWithHistory {
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

    component RoundBtn: StyledRect {
        id: rb

        property string glyph
        property bool dim

        signal tapped

        implicitWidth: 44
        implicitHeight: 44
        radius: Tokens.rounding.full
        color: Colours.palette.m3secondaryContainer
        opacity: dim ? 0.4 : 1

        StateLayer {
            radius: rb.radius
            onClicked: rb.tapped()
        }
        MaterialIcon {
            anchors.centerIn: parent
            text: rb.glyph
            color: Colours.palette.m3onSecondaryContainer
        }
    }

    StyledRect {
        id: card

        anchors.centerIn: parent
        width: Math.min(parent.width - 48, 900)
        height: Math.min(parent.height - 48, 620)
        radius: Tokens.rounding.extraLarge
        color: Colours.palette.m3surfaceContainerHigh
        scale: root.shown ? 1 : 0.94

        Behavior on scale {
            Anim {}
        }

        MouseArea {
            anchors.fill: parent
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Tokens.padding.extraLarge
            spacing: Tokens.spacing.large

            RowLayout {
                Layout.fillWidth: true

                StyledText {
                    Layout.fillWidth: true
                    text: root.title
                    font: Tokens.font.title.large
                }
                RoundBtn {
                    glyph: "close"
                    onTapped: root.close()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Tokens.spacing.small

                RoundBtn {
                    glyph: "arrow_back"
                    dim: fm.currentFolderHistoryIndex <= 0
                    onTapped: fm.navigateBack()
                }
                RoundBtn {
                    glyph: "arrow_upward"
                    onTapped: fm.navigateUp()
                }
                StyledRect {
                    Layout.fillWidth: true
                    implicitHeight: 44
                    radius: Tokens.rounding.full
                    color: Colours.palette.m3surfaceContainerLowest

                    StyledText {
                        anchors.fill: parent
                        anchors.leftMargin: Tokens.padding.large
                        anchors.rightMargin: Tokens.padding.large
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideLeft
                        text: decodeURIComponent(fm.folder.toString().replace("file://", ""))
                        color: Colours.palette.m3onSurfaceVariant
                        font: Tokens.font.label.medium
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Tokens.spacing.large

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 170

                    Column {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        spacing: 4

                        Repeater {
                            model: [
                                { i: "home", l: Tr.tr("Home"), p: "" },
                                { i: "image", l: Tr.tr("Pictures"), p: "/Pictures" },
                                { i: "download", l: Tr.tr("Downloads"), p: "/Downloads" },
                                { i: "description", l: Tr.tr("Documents"), p: "/Documents" },
                                { i: "desktop_windows", l: Tr.tr("Desktop"), p: "/Desktop" }
                            ]

                            StyledRect {
                                id: place

                                required property var modelData
                                readonly property string dest: "file://" + root.home + modelData.p
                                readonly property bool here: fm.folder.toString() === dest

                                width: parent.width
                                height: 48
                                radius: here ? Tokens.rounding.full : Tokens.rounding.medium
                                color: here ? Colours.palette.m3secondaryContainer : "transparent"

                                StateLayer {
                                    radius: place.radius
                                    onClicked: fm.folder = place.dest
                                }
                                MaterialIcon {
                                    id: pIcon

                                    anchors.left: parent.left
                                    anchors.leftMargin: Tokens.padding.large
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: place.modelData.i
                                    fill: place.here ? 1 : 0
                                    color: place.here ? Colours.palette.m3onSecondaryContainer : Colours.palette.m3onSurfaceVariant
                                }
                                StyledText {
                                    anchors.left: pIcon.right
                                    anchors.leftMargin: Tokens.spacing.medium
                                    anchors.right: parent.right
                                    anchors.rightMargin: Tokens.padding.medium
                                    anchors.verticalCenter: parent.verticalCenter
                                    elide: Text.ElideRight
                                    text: place.modelData.l
                                    font: Tokens.font.body.small
                                    color: place.here ? Colours.palette.m3onSecondaryContainer : Colours.palette.m3onSurface
                                }
                            }
                        }
                    }
                }

                StyledRect {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: Tokens.rounding.large
                    color: Colours.palette.m3surface
                    clip: true

                    GridView {
                        id: grid

                        readonly property int perRow: Math.max(1, Math.floor(width / 132))

                        anchors.fill: parent
                        anchors.margins: Tokens.padding.medium
                        clip: true
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

                            StyledRect {
                                id: tile

                                anchors.fill: parent
                                anchors.margins: 5
                                radius: cell.sel ? Tokens.rounding.medium : Tokens.rounding.large
                                color: cell.sel ? Colours.palette.m3primaryContainer : Colours.palette.m3surfaceContainer

                                StateLayer {
                                    radius: tile.radius
                                    onClicked: cell.fileIsDir ? fm.folder = "file://" + cell.filePath : root.selected = cell.filePath
                                    onDoubleClicked: {
                                        if (!cell.fileIsDir) {
                                            root.selected = cell.filePath;
                                            root.accept();
                                        }
                                    }
                                }

                                MaterialIcon {
                                    visible: cell.fileIsDir
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top
                                    anchors.topMargin: 22
                                    text: "folder"
                                    fill: 1
                                    fontStyle: Tokens.font.icon.extraLarge
                                    color: Colours.palette.m3primary
                                }
                                Item {
                                    id: thumb

                                    visible: !cell.fileIsDir
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.bottom: lbl.top
                                    anchors.margins: 6
                                    anchors.bottomMargin: 4

                                    Image {
                                        anchors.fill: parent
                                        source: cell.fileIsDir ? "" : "file://" + cell.filePath
                                        sourceSize: Qt.size(240, 240)
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                        cache: false
                                        layer.enabled: true
                                        layer.effect: OpacityMask {
                                            maskSource: Rectangle {
                                                width: thumb.width
                                                height: thumb.height
                                                radius: 14
                                            }
                                        }
                                    }
                                }
                                StyledText {
                                    id: lbl

                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.margins: 8
                                    anchors.bottomMargin: 6
                                    height: 18
                                    horizontalAlignment: Text.AlignHCenter
                                    elide: Text.ElideMiddle
                                    text: cell.fileName
                                    font: Tokens.font.label.small
                                    color: cell.sel ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface
                                }
                            }
                        }
                    }

                    StyledText {
                        visible: grid.count === 0
                        anchors.centerIn: parent
                        text: Tr.tr("No pictures in this folder")
                        color: Colours.palette.m3outline
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Tokens.spacing.medium

                StyledText {
                    Layout.fillWidth: true
                    elide: Text.ElideMiddle
                    text: root.selected.length > 0 ? root.selected.split("/").pop() : Tr.tr("Pick a picture")
                    color: Colours.palette.m3onSurfaceVariant
                    font: Tokens.font.body.small
                }
                StyledRect {
                    implicitWidth: cancelT.implicitWidth + 40
                    implicitHeight: 44
                    radius: Tokens.rounding.full
                    color: Colours.palette.m3secondaryContainer

                    StateLayer {
                        radius: parent.radius
                        onClicked: root.close()
                    }
                    StyledText {
                        id: cancelT

                        anchors.centerIn: parent
                        text: Tr.tr("Cancel")
                        font: Tokens.font.label.medium
                        color: Colours.palette.m3onSecondaryContainer
                    }
                }
                StyledRect {
                    implicitWidth: okT.implicitWidth + 40
                    implicitHeight: 44
                    radius: Tokens.rounding.full
                    color: Colours.palette.m3primary
                    opacity: root.selected.length > 0 ? 1 : 0.4

                    StateLayer {
                        radius: parent.radius
                        disabled: root.selected.length === 0
                        onClicked: root.accept()
                    }
                    StyledText {
                        id: okT

                        anchors.centerIn: parent
                        text: Tr.tr("Select")
                        font: Tokens.font.label.medium
                        color: Colours.palette.m3onPrimary
                    }
                }
            }
        }
    }
}
