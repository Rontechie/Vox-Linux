pragma Singleton

import qs.modules.common
import qs.modules.common.functions
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string killDialogQmlPath: FileUtils.trimFileProtocol(Quickshell.shellPath("killDialog.qml"))

    function load() {
    }

    Connections {
        target: Config
        function onReadyChanged() {
            if (Config.ready) checkConflictsProc.running = true
        }
    }

    Process {
        id: checkConflictsProc
        command: ["bash", "-c", `echo "$(pidof kded6);$(pidof mako dunst swaync fnott)"`]
        stdout: StdioCollector {
            onStreamFinished: {
                const output = this.text;
                const conflictingTrays = output.split(";")[0].trim().length > 0;
                const conflictingNotifications = output.split(";")[1].trim().length > 0;
                if (conflictingTrays) {
                    if (!Config.options.conflictKiller.autoKillTrays) console.warn("[ConflictKiller] kded6 is running and may take over the tray")
                    else Quickshell.execDetached(["killall", "kded6"])
                }
                if (conflictingNotifications) {
                    if (!Config.options.conflictKiller.autoKillNotificationDaemons) console.warn("[ConflictKiller] another notification daemon is running; Hydro's notifications will not show")
                    else Quickshell.execDetached(["bash", "-c", "pkill -x mako; pkill -x dunst; pkill -x swaync; pkill -x fnott; true"])
                }
            }
        }
    }
}
