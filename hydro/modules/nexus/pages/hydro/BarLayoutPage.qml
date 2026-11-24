pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.modules.common as HC
import qs.modules.nexus.compat
import qs.modules.nexus.components
import qs.modules.nexus.components.controls
import qs.modules.nexus.services
import qs.modules.nexus.common

PageBase {
    id: root

    readonly property var layout: HC.Config.options.bar.hydroLayout
    readonly property var names: ({
            logo: Tr.tr("Launcher logo"),
            windowTitle: Tr.tr("Window title"),
            workspaces: Tr.tr("Workspaces"),
            tray: Tr.tr("System tray"),
            status: Tr.tr("Status icons"),
            clock: Tr.tr("Clock"),
            launcher: Tr.tr("Launcher"),
            leftSidebar: Tr.tr("Left sidebar button"),
            activeWindow: Tr.tr("Active window"),
            media: Tr.tr("Media"),
            resources: Tr.tr("Resources"),
            cpu: Tr.tr("CPU"),
            ram: Tr.tr("Memory"),
            network: Tr.tr("Network"),
            battery: Tr.tr("Battery"),
            notifications: Tr.tr("Notifications"),
            weather: Tr.tr("Weather"),
            utilButtons: Tr.tr("Utility buttons")
        })
    readonly property var allIds: Object.keys(names)
    readonly property var lanes: ["left", "center", "right"]
    readonly property var addable: allIds.filter(id => !lanes.some(l => Array.from(layout[l]).indexOf(id) >= 0))

    function labelOf(id: string): string {
        return names[id] ?? id;
    }

    function itemsOf(lane: string): var {
        return Array.from(layout[lane]).map(id => ({
                    id: id,
                    label: labelOf(id)
                }));
    }

    function move(lane: string, from: int, to: int): void {
        const a = Array.from(layout[lane]);
        const x = a.splice(from, 1)[0];
        a.splice(to, 0, x);
        layout[lane] = a;
    }

    function remove(lane: string, index: int): void {
        const a = Array.from(layout[lane]);
        a.splice(index, 1);
        layout[lane] = a;
    }

    function add(lane: string, id: string): void {
        const a = Array.from(layout[lane]);
        a.push(id);
        layout[lane] = a;
    }

    title: Tr.tr("Widget layout")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        Repeater {
            model: [
                {
                    lane: "left",
                    title: Tr.tr("Start")
                },
                {
                    lane: "center",
                    title: Tr.tr("Centre")
                },
                {
                    lane: "right",
                    title: Tr.tr("End")
                }
            ]

            ColumnLayout {
                id: section

                required property var modelData
                required property int index

                Layout.fillWidth: true
                spacing: Tokens.spacing.extraSmall / 2

                SectionHeader {
                    first: section.index === 0
                    text: section.modelData.title
                }

                ListEditor {
                    function labelFor(item: var): string {
                        return item.label;
                    }

                    z: 3 - section.index
                    first: true
                    values: root.itemsOf(section.modelData.lane)
                    onItemMoved: (from, to) => root.move(section.modelData.lane, from, to)
                    onItemRemoved: index => root.remove(section.modelData.lane, index)
                }

                DialogSelectButton {
                    rootParent: root.flickable
                    icon: "add"
                    label: Tr.tr("Add widget")
                    header: Tr.tr("Add a widget")
                    acceptLabel: Tr.trCtx("Add", "button")
                    model: root.addable.map(id => ({
                                id: id,
                                label: root.labelOf(id)
                            }))

                    onAccepted: {
                        if (selectedItem)
                            root.add(section.modelData.lane, selectedItem);
                    }
                }
            }
        }
    }
}
