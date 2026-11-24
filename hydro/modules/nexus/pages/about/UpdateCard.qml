pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.modules.nexus.compat
import qs.modules.nexus.components
import qs.modules.nexus.components.controls
import qs.modules.nexus.services
import qs.modules.nexus.common

ConnectedRect {
    id: root

    required property var updater
    readonly property int st: updater.status

    property bool showPackages: false
    property bool showLog: false

    first: true
    last: true
    Layout.fillWidth: true
    implicitHeight: col.implicitHeight + Tokens.padding.large * 2
    clip: true

    Behavior on implicitHeight {
        Anim { type: Anim.DefaultSpatial }
    }

    readonly property bool isDone: st === SystemUpdater.UpToDate || st === SystemUpdater.Done
    readonly property string iconName: {
        switch (st) {
        case SystemUpdater.UpToDate: return "check_circle";
        case SystemUpdater.Done: return "task_alt";
        case SystemUpdater.Available: return "system_update";
        case SystemUpdater.Updating: return "downloading";
        case SystemUpdater.Failed: return "error";
        case SystemUpdater.Unsupported: return "block";
        default: return "update";
        }
    }
    readonly property color bubbleColour: {
        if (isDone) return Colours.palette.m3primaryContainer;
        if (st === SystemUpdater.Available) return Colours.palette.m3tertiaryContainer;
        if (st === SystemUpdater.Failed) return Colours.palette.m3errorContainer;
        return Colours.palette.m3secondaryContainer;
    }
    readonly property color onBubbleColour: {
        if (isDone) return Colours.palette.m3onPrimaryContainer;
        if (st === SystemUpdater.Available) return Colours.palette.m3onTertiaryContainer;
        if (st === SystemUpdater.Failed) return Colours.palette.m3onErrorContainer;
        return Colours.palette.m3onSecondaryContainer;
    }
    readonly property string title: {
        switch (st) {
        case SystemUpdater.Checking: return Tr.tr("Checking for updates…");
        case SystemUpdater.UpToDate: return Tr.tr("Your system is up to date");
        case SystemUpdater.Available: return updater.count === 1 ? Tr.tr("1 update available") : Tr.tr("%1 updates available").replace("%1", updater.count);
        case SystemUpdater.Updating: return Tr.tr("Updating your system");
        case SystemUpdater.Done: return Tr.tr("Update complete");
        case SystemUpdater.Failed: return Tr.tr("Something went wrong");
        case SystemUpdater.Unsupported: return Tr.tr("Updates aren't available");
        default: return Tr.tr("Software update");
        }
    }
    readonly property string subtitle: {
        switch (st) {
        case SystemUpdater.Idle: return Tr.tr("Check whether your system is up to date");
        case SystemUpdater.Checking: return Tr.tr("Syncing with the package servers");
        case SystemUpdater.UpToDate:
            return updater.lastChecked ? Tr.tr("Last checked at %1").replace("%1", Qt.formatTime(updater.lastChecked, "hh:mm")) : "";
        case SystemUpdater.Available: {
            const names = updater.packages.slice(0, 3).map(p => p.name).join(", ");
            const more = updater.count - 3;
            return more > 0 ? Tr.tr("%1 and %2 more").replace("%1", names).replace("%2", more) : names;
        }
        case SystemUpdater.Updating: return updater.phase;
        case SystemUpdater.Done: return updater.restartRecommended ? Tr.tr("Restart recommended to finish applying the update") : Tr.tr("Everything is installed");
        case SystemUpdater.Failed: return updater.error;
        case SystemUpdater.Unsupported:
            return updater.missing ? Tr.tr("Missing: %1 (needs an Arch-based system with pacman-contrib)").replace("%1", updater.missing) : Tr.tr("Needs an Arch-based system");
        default: return "";
        }
    }

    ColumnLayout {
        id: col

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Tokens.padding.large
        spacing: Tokens.spacing.medium

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.large

            StyledRect {
                id: bubble

                Layout.preferredWidth: 60
                Layout.preferredHeight: 60
                color: root.bubbleColour
                radius: root.updater.busy ? Tokens.rounding.large : width / 2
                Behavior on radius {
                    Anim { type: Anim.DefaultSpatial }
                }

                SequentialAnimation {
                    id: pop
                    Anim { target: bubble; property: "scale"; to: 0.82; type: Anim.FastEffects }
                    Anim { target: bubble; property: "scale"; to: 1; type: Anim.FastSpatial }
                }
                Connections {
                    target: root.updater
                    function onStatusChanged(): void {
                        pop.restart();
                    }
                }

                MaterialIcon {
                    anchors.centerIn: parent
                    text: root.iconName
                    color: root.onBubbleColour
                    fill: root.isDone ? 1 : 0
                    fontStyle: Tokens.font.icon.large
                    opacity: root.updater.status === SystemUpdater.Checking ? 0 : 1
                    Behavior on opacity {
                        Anim { type: Anim.FastEffects }
                    }
                }
                LoadingIndicator {
                    anchors.centerIn: parent
                    implicitSize: 32
                    color: root.onBubbleColour
                    opacity: root.updater.status === SystemUpdater.Checking ? 1 : 0
                    Behavior on opacity {
                        Anim { type: Anim.FastEffects }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                StyledText {
                    Layout.fillWidth: true
                    text: root.title
                    animate: true
                    elide: Text.ElideRight
                    font: Tokens.font.title.medium
                }
                StyledText {
                    Layout.fillWidth: true
                    text: root.subtitle
                    animate: true
                    visible: text.length > 0
                    color: root.st === SystemUpdater.Failed ? Colours.palette.m3error : Colours.palette.m3onSurfaceVariant
                    font: Tokens.font.body.small
                    wrapMode: Text.Wrap
                    maximumLineCount: 3
                    elide: Text.ElideRight
                }
            }

            IconTextButton {
                id: action

                readonly property bool available: root.st === SystemUpdater.Available

                visible: root.st !== SystemUpdater.Unsupported
                disabled: root.updater.busy
                type: IconTextButton.Filled
                isRound: true
                horizontalPadding: Tokens.padding.large
                verticalPadding: Tokens.padding.medium
                icon: available ? "system_update_alt" : "refresh"
                text: {
                    if (root.st === SystemUpdater.Checking) return Tr.tr("Checking…");
                    if (root.st === SystemUpdater.Updating) return Tr.tr("Updating…");
                    if (available) return Tr.tr("Update now");
                    return Tr.tr("Check for updates");
                }
                font: Tokens.font.label.large

                Behavior on implicitWidth {
                    Anim { type: Anim.DefaultSpatial }
                }

                onClicked: available ? root.updater.update() : root.updater.check()
            }
        }

        StyledProgressBar {
            Layout.fillWidth: true
            visible: root.st === SystemUpdater.Updating
            indeterminate: root.updater.progress < 0
            value: root.updater.progress
            implicitHeight: Tokens.rounding.small
        }
        StyledText {
            Layout.alignment: Qt.AlignRight
            visible: root.st === SystemUpdater.Updating && root.updater.total > 0
            text: `${root.updater.current} / ${root.updater.total}`
            color: Colours.palette.m3onSurfaceVariant
            font: Tokens.font.label.small
        }

        TextButton {
            Layout.alignment: Qt.AlignLeft
            visible: root.st === SystemUpdater.Available
            type: TextButton.Text
            text: root.showPackages ? Tr.tr("Hide packages") : Tr.tr("Show packages")
            font: Tokens.font.label.medium
            onClicked: root.showPackages = !root.showPackages
        }
        Item {
            Layout.fillWidth: true
            visible: root.st === SystemUpdater.Available
            implicitHeight: root.showPackages ? Math.min(220, pkgCol.implicitHeight + Tokens.padding.medium * 2) : 0
            clip: true
            Behavior on implicitHeight {
                Anim { type: Anim.DefaultSpatial }
            }

            StyledRect {
                anchors.fill: parent
                radius: Tokens.rounding.large
                color: Colours.tPalette.m3surfaceContainerHigh
            }
            Flickable {
                anchors.fill: parent
                anchors.margins: Tokens.padding.medium
                contentHeight: pkgCol.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: pkgCol
                    width: parent.width
                    spacing: 2
                    Repeater {
                        model: root.updater.packages
                        delegate: RowLayout {
                            id: pkgRow
                            required property var modelData
                            width: pkgCol.width
                            StyledText {
                                Layout.fillWidth: true
                                text: pkgRow.modelData.name
                                elide: Text.ElideRight
                                font: Tokens.font.body.small
                            }
                            StyledText {
                                text: `${pkgRow.modelData.from} → ${pkgRow.modelData.to}`
                                color: Colours.palette.m3onSurfaceVariant
                                font: Tokens.font.mono.small
                            }
                        }
                    }
                }
            }
        }

        StyledRect {
            Layout.fillWidth: true
            visible: root.st === SystemUpdater.Done && root.updater.restartRecommended
            implicitHeight: hint.implicitHeight + Tokens.padding.medium * 2
            radius: Tokens.rounding.large
            color: Colours.palette.m3tertiaryContainer
            RowLayout {
                id: hint
                anchors.fill: parent
                anchors.margins: Tokens.padding.medium
                spacing: Tokens.spacing.small
                MaterialIcon {
                    text: "restart_alt"
                    color: Colours.palette.m3onTertiaryContainer
                }
                StyledText {
                    Layout.fillWidth: true
                    text: Tr.tr("A kernel or driver was updated. Reboot when convenient.")
                    wrapMode: Text.Wrap
                    color: Colours.palette.m3onTertiaryContainer
                    font: Tokens.font.body.small
                }
            }
        }

        TextButton {
            Layout.alignment: Qt.AlignLeft
            visible: root.updater.logLines.length > 0
            type: TextButton.Text
            text: root.showLog ? Tr.tr("Hide details") : Tr.tr("Show details")
            font: Tokens.font.label.medium
            onClicked: root.showLog = !root.showLog
        }
        Item {
            Layout.fillWidth: true
            visible: root.updater.logLines.length > 0
            implicitHeight: root.showLog ? 200 : 0
            clip: true
            Behavior on implicitHeight {
                Anim { type: Anim.DefaultSpatial }
            }

            StyledRect {
                anchors.fill: parent
                radius: Tokens.rounding.large
                color: Colours.tPalette.m3surfaceContainerHighest
            }
            Flickable {
                id: logFlick
                anchors.fill: parent
                anchors.margins: Tokens.padding.medium
                contentWidth: width
                contentHeight: logText.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                onContentHeightChanged: contentY = Math.max(0, contentHeight - height)

                StyledText {
                    id: logText
                    width: logFlick.width
                    text: root.updater.logLines.join("\n")
                    wrapMode: Text.WrapAnywhere
                    color: Colours.palette.m3onSurfaceVariant
                    font: Tokens.font.mono.small
                }
            }
        }
    }
}
