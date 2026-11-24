pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common
import qs.modules.nexus.utils
import qs.services as HydroServices

Singleton {
    id: root

    property var list: []
    readonly property string current: Config.options.background.wallpaperPath
    property bool showPreview: false

    function getCategoryFor(w: var): string {
        let category = w.parentDir.slice(Paths.wallsdir.length + 1);
        if (category.includes("/"))
            category = category.slice(0, category.indexOf("/"));
        return category;
    }

    function setWallpaper(path: string): void {
        HydroServices.Wallpapers.apply(path);
    }

    function setRandom(): void {
        if (list.length === 0)
            return;
        setWallpaper(list[Math.floor(Math.random() * list.length)].path);
    }

    function browse(): void {
        HydroServices.Wallpapers.openFallbackPicker();
    }

    function preview(path: string): void {
    }

    function stopPreview(): void {
    }

    function refresh(): void {
        scan.running = false;
        scan.running = true;
    }

    Component.onCompleted: refresh()

    Process {
        id: scan

        command: ["find", "-L", Paths.wallsdir, "-type", "f", "(", "-iname", "*.jpg", "-o", "-iname", "*.jpeg", "-o", "-iname", "*.png", "-o", "-iname", "*.webp", "-o", "-iname", "*.tif", "-o", "-iname", "*.tiff", "-o", "-iname", "*.svg", ")"]
        stdout: StdioCollector {
            onStreamFinished: {
                const out = [];
                for (const path of text.split("\n")) {
                    if (!path)
                        continue;
                    const i = path.lastIndexOf("/");
                    out.push({
                        "path": path,
                        "name": path.slice(i + 1),
                        "parentDir": path.slice(0, i)
                    });
                }
                out.sort((a, b) => a.path.localeCompare(b.path));
                root.list = out;
            }
        }
    }
}
