import qs.modules.common
import qs.modules.common.panels.lock
import QtQuick

LockScreen {
    id: root
    lockSurface: Config.options.lock.style === "iridium" ? iridiumSurface : hydroSurface

    Component {
        id: hydroSurface
        LockSurface { context: root.context }
    }
    Component {
        id: iridiumSurface
        IridiumSurface { context: root.context }
    }
}
