pragma Singleton

import QtQuick
import qs.modules.nexus.compat

QtObject {
    id: root

    readonly property list<var> pages: [
        {
            label: Tr.tr("Wallpaper & style"),
            icon: "palette",
            description: Tr.tr("Wallpaper, colours, light/dark, transparency"),
            category: "appearance"
        },

        {
            label: Tr.tr("Profile"),
            icon: "account_circle",
            description: Tr.tr("Profile picture"),
            category: "appearance"
        },
        {
            label: Tr.tr("Background & lock"),
            icon: "wallpaper",
            description: Tr.tr("Clock, widgets, lock screen"),
            category: "appearance"
        },
        {
            label: Tr.tr("Desktop widgets"),
            icon: "widgets",
            description: Tr.tr("Media, weather, system, stopwatch, cava"),
            category: "appearance"
        },

        {
            label: Tr.tr("Network"),
            icon: "wifi",
            description: Tr.tr("Wi-Fi, ethernet, VPN"),
            category: "connectivity"
        },
        {
            label: Tr.tr("Connected devices"),
            icon: "devices_other",
            description: Tr.tr("Bluetooth, pairing"),
            category: "connectivity",
            noFill: true
        },
        {
            label: Tr.tr("Audio"),
            icon: "volume_up",
            description: Tr.tr("App volumes, sound devices"),
            category: "connectivity"
        },

        {
            label: Tr.tr("Bar"),
            icon: "dock_to_bottom",
            description: Tr.tr("Position, style, workspaces"),
            category: "shell"
        },
        {
            label: Tr.tr("Dashboard & sidebar"),
            icon: "dashboard",
            description: Tr.tr("Dashboard, sidebars, launcher"),
            category: "shell"
        },
        {
            label: Tr.tr("Dock & overview"),
            icon: "call_to_action",
            description: Tr.tr("Dock, overview, screen corners"),
            category: "shell"
        },
        {
            label: Tr.tr("Time & notifications"),
            icon: "schedule",
            description: Tr.tr("Clock, weather, popups"),
            category: "shell"
        },
        {
            label: Tr.tr("Power & sound"),
            icon: "battery_charging_full",
            description: Tr.tr("Battery, sounds, power"),
            category: "shell"
        },

        {
            label: Tr.tr("Launcher"),
            icon: "apps",
            description: Tr.tr("App grid, favourites, power bar, bar button"),
            category: "shell"
        },

        {
            label: Tr.tr("About"),
            icon: "info",
            description: Tr.tr("System information, credits"),
            category: "about"
        },
    ]
}
