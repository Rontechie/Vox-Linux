import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors { bottom: true; left: true; right: true }
            implicitHeight: Theme.barHeight + Theme.barGap * 2
            color: "transparent"

            Rectangle {
                anchors {
                    fill: parent
                    leftMargin: Theme.barGap
                    rightMargin: Theme.barGap
                    topMargin: Theme.barGap
                    bottomMargin: Theme.barGap
                }
                radius: Theme.radius
                color: Theme.bg

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: Theme.spacing

                    Workspaces {}
                    WindowTitle { Layout.fillWidth: true }
                    Tray {}
                    Volume {}
                    Battery {}
                    Clock {}
                }
            }
        }
    }
}
