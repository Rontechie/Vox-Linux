import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    readonly property string dir: FileUtils.trimFileProtocol((params && params.dir) ? params.dir : Wallpapers.effectiveDirectory)
    readonly property string current: Config.options.background.wallpaperPath
    readonly property int columns: Math.max(2, Math.floor(page.cappedWidth / 210))

    function baseName(p) {
        const parts = String(p).split("/").filter(s => s.length > 0);
        return parts.length > 0 ? parts[parts.length - 1] : "/";
    }

    FolderListModel {
        id: folderModel
        folder: "file://" + page.dir
        nameFilters: Wallpapers.extensions.map(e => "*." + e)
        showDirs: true
        showDirsFirst: true
        showDotAndDotDot: false
        showOnlyReadable: true
        sortField: FolderListModel.Name
    }

    NxGroup {
        NxButtonRow {
            icon: "photo_library"; text: Translation.tr("Choose file")
            subtext: Translation.tr("Pick an image with your file chooser")
            onClicked: Wallpapers.openFallbackPicker()
        }
        NxButtonRow {
            icon: "shuffle"; text: Translation.tr("Random from this folder")
            subtext: page.dir
            disabled: folderModel.count === 0
            onClicked: {
                const files = [];
                for (let i = 0; i < folderModel.count; i++)
                    if (!folderModel.get(i, "fileIsDir")) files.push(folderModel.get(i, "filePath"));
                if (files.length > 0) Wallpapers.apply(files[Math.floor(Math.random() * files.length)]);
            }
        }
        NxButtonRow {
            icon: "arrow_upward"; text: Translation.tr("Parent folder")
            visible: page.dir !== "/"
            onClicked: {
                const up = page.dir.replace(/\/[^\/]+\/?$/, "") || "/";
                NxNav.push(page.baseName(up), "modules/settings/nexus/wallpaper/WallpaperBrowsePage.qml", { dir: up });
            }
        }
    }

    NxHeader { text: page.dir }
    GridLayout {
        Layout.fillWidth: true
        Layout.topMargin: 6
        columns: page.columns
        rowSpacing: 14
        columnSpacing: 14
        Repeater {
            model: folderModel
            delegate: NzWallItem {
                required property string fileName
                required property string filePath
                required property bool fileIsDir
                isFolder: fileIsDir
                path: fileIsDir ? "" : filePath
                text: fileName
                selected: !fileIsDir && filePath === page.current
                onClicked: {
                    if (fileIsDir)
                        NxNav.push(fileName, "modules/settings/nexus/wallpaper/WallpaperBrowsePage.qml", { dir: filePath });
                    else
                        Wallpapers.apply(filePath);
                }
            }
        }
    }
    StyledText {
        visible: folderModel.count === 0
        Layout.fillWidth: true
        Layout.topMargin: 24
        horizontalAlignment: Text.AlignHCenter
        text: Translation.tr("No images in this folder")
        color: Appearance.m3colors.m3outline
    }
}
