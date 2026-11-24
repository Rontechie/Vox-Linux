import qs
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: root
    readonly property string wallpaper: Config.options.background.wallpaperPath || Config.options.background.thumbnailPath
    readonly property string facePath: "file://" + Quickshell.env("HOME") + "/.face"

    Layout.fillWidth: true
    implicitHeight: 128

    Rectangle { // rounded mask for the image
        id: roundMask
        anchors.fill: parent
        radius: Appearance.rounding.large
        visible: false
    }

    Item {
        anchors.fill: parent
        layer.enabled: true
        layer.effect: OpacityMask { maskSource: roundMask }

        Rectangle { // fallback when there is no usable wallpaper
            anchors.fill: parent
            color: Appearance.colors.colLayer1
        }
        Image {
            anchors.fill: parent
            source: root.wallpaper !== "" ? (root.wallpaper.startsWith("file://") ? root.wallpaper : "file://" + root.wallpaper) : ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
            sourceSize.width: 900
        }
        Rectangle { // soft black gradient, stronger at the bottom so the text stays readable
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.35; color: "#00000000" }
                GradientStop { position: 1.0; color: "#b3000000" }
            }
        }
    }

    RowLayout {
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 14
            bottomMargin: 12
        }
        spacing: 10

        ProfileAvatar { // profile picture, falls back to a person icon
            Layout.preferredWidth: 44
            Layout.preferredHeight: 44
            size: 44
            ringWidth: 2
        }

        ColumnLayout {
            spacing: 0
            StyledText {
                text: SystemInfo.username
                font.pixelSize: Appearance.font.pixelSize.larger
                font.weight: Font.Medium
                color: "white"
            }
            RowLayout {
                spacing: 4
                MaterialSymbol {
                    text: "schedule"
                    iconSize: Appearance.font.pixelSize.normal
                    color: "#ccffffff"
                }
                StyledText {
                    text: Translation.tr("Up %1").arg(DateTime.uptime)
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    color: "#ccffffff"
                }
            }
        }
    }

    property bool editMode: false
    signal editToggled()

    component HeaderButton: Rectangle {
        id: hb
        property string icon
        property bool active: false
        signal clicked()
        implicitWidth: 34
        implicitHeight: 34
        radius: width / 2
        color: active ? Appearance.colors.colPrimary
                      : (hbMouse.containsMouse ? "#99000000" : "#59000000")
        Behavior on color { ColorAnimation { duration: 120 } }
        MaterialSymbol {
            anchors.centerIn: parent
            text: hb.icon
            iconSize: Appearance.font.pixelSize.larger
            color: hb.active ? Appearance.colors.colOnPrimary : "white"
        }
        MouseArea {
            id: hbMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: hb.clicked()
        }
    }

    Row {
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 10
            rightMargin: 10
        }
        spacing: 6

        HeaderButton {
            visible: Config.options.sidebar.quickToggles.style === "android"
            icon: "edit"
            active: root.editMode
            onClicked: root.editToggled()
        }
        HeaderButton {
            icon: "restart_alt"
            onClicked: {
                Quickshell.execDetached(["hyprctl", "reload"]);
                Quickshell.reload(true);
            }
        }
        HeaderButton {
            icon: "settings"
            onClicked: {
                GlobalStates.sidebarRightOpen = false;
                Quickshell.execDetached(["qs", "-p", Quickshell.shellPath("nexus.qml")]);
            }
        }
        HeaderButton {
            icon: "power_settings_new"
            onClicked: GlobalStates.sessionOpen = true
        }
    }
}
