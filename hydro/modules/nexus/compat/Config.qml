pragma Singleton

import Quickshell

Singleton {
    readonly property var background: GlobalConfig.background
    readonly property var nexus: GlobalConfig.nexus
    readonly property var services: GlobalConfig.services
    readonly property var appearance: GlobalConfig.appearance
    readonly property var general: GlobalConfig.general
    readonly property var utilities: GlobalConfig.utilities
    readonly property var paths: GlobalConfig.paths
    readonly property var bar: GlobalConfig.bar
}
