import QtQuick
import Quickshell
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.modules.common.widgets.settings

ContentSection {
    icon: "schedule"
    title: Translation.tr("Time Format")

    SettingsDropdownRow {
        text: Translation.tr("Clock format")
        description: Translation.tr("Used by the bar, lock screen and widgets")
        options: [Translation.tr("24-hour"), Translation.tr("12-hour (am/pm)"), Translation.tr("12-hour (AM/PM)")]
        values: ["hh:mm", "h:mm ap", "h:mm AP"]
        currentValue: Config.options.time.format
        onValueChanged: v => {
            const conf = `${FileUtils.trimFileProtocol(Directories.config)}/hypr/hyprlock.conf`;
            if (v === "hh:mm")
                Quickshell.execDetached(["bash", "-c", `sed -i 's/\\TIME12\\b/TIME/' '${conf}'`]);
            else
                Quickshell.execDetached(["bash", "-c", `sed -i 's/\\TIME\\b/TIME12/' '${conf}'`]);
            Config.options.time.format = v;
        }
    }
    SettingsToggleRow {
        text: Translation.tr("Show seconds")
        description: Translation.tr("Makes clocks tick every second")
        checked: Config.options.time.secondPrecision
        onToggled: c => Config.options.time.secondPrecision = c
    }
}
