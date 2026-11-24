import qs.modules.common
import qs.modules.common.functions
import Qt5Compat.GraphicalEffects
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

MaterialShape { // App icon
    id: root
    property var appIcon: ""
    property var summary: ""
    property var urgency: NotificationUrgency.Normal
    property bool isUrgent: urgency === NotificationUrgency.Critical
    property var image: ""
    property real materialIconScale: 0.57
    property real appIconScale: 0.8
    property real smallAppIconScale: 0.49
    property real materialIconSize: implicitSize * materialIconScale
    property real appIconSize: implicitSize * appIconScale
    property real smallAppIconSize: implicitSize * smallAppIconScale

    implicitSize: 48 * scale
    readonly property string seed: String(root.appIcon || root.summary || "")
    readonly property int hash: {
        let h = 0;
        for (let i = 0; i < seed.length; i++) h = (h * 31 + seed.charCodeAt(i)) | 0;
        return Math.abs(h);
    }
    property list<var> urgentShapes: [
        MaterialShape.Shape.VerySunny,
        MaterialShape.Shape.Boom,
    ]
    property list<var> shapePool: [
        MaterialShape.Shape.Cookie9Sided,
        MaterialShape.Shape.Clover4Leaf,
        MaterialShape.Shape.Flower,
        MaterialShape.Shape.SoftBurst,
        MaterialShape.Shape.Cookie7Sided,
        MaterialShape.Shape.Pentagon,
    ]
    readonly property int tone: hash % 3 // 0 secondary, 1 tertiary, 2 primary
    shape: isUrgent ? urgentShapes[hash % urgentShapes.length] : shapePool[hash % shapePool.length]

    readonly property color containerColor: isUrgent ? Appearance.colors.colPrimaryContainer
        : tone === 0 ? Appearance.colors.colSecondaryContainer
        : tone === 1 ? Appearance.colors.colTertiaryContainer
        : Appearance.colors.colPrimaryContainer
    readonly property color onContainerColor: isUrgent ? Appearance.colors.colOnPrimaryContainer
        : tone === 0 ? Appearance.colors.colOnSecondaryContainer
        : tone === 1 ? Appearance.colors.colOnTertiaryContainer
        : Appearance.colors.colOnPrimaryContainer
    color: containerColor
    Loader {
        id: materialSymbolLoader
        active: root.appIcon == "" && root.image == ""
        anchors.fill: parent
        sourceComponent: MaterialSymbol {
            text: {
                const defaultIcon = NotificationUtils.findSuitableMaterialSymbol("")
                const guessedIcon = NotificationUtils.findSuitableMaterialSymbol(root.summary)
                return (root.urgency == NotificationUrgency.Critical && guessedIcon === defaultIcon) ?
                    "priority_high" : guessedIcon
            }
            anchors.fill: parent
            color: root.onContainerColor
            iconSize: root.materialIconSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    Loader {
        id: appIconLoader
        active: root.image == "" && root.appIcon != ""
        anchors.centerIn: parent
        sourceComponent: IconImage {
            id: appIconImage
            implicitSize: root.appIconSize
            asynchronous: true
            source: Quickshell.iconPath(root.appIcon, "image-missing")
        }
    }
    Loader {
        id: notifImageLoader
        active: root.image != ""
        anchors.fill: parent
        sourceComponent: Item {
            anchors.fill: parent
            StyledImage {
                id: notifImage
                anchors.fill: parent
                readonly property int size: parent.width

                source: root.image
                fillMode: Image.PreserveAspectCrop
                cache: false
                antialiasing: true
                asynchronous: true

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: notifImage.size
                        height: notifImage.size
                        radius: Appearance.rounding.full
                    }
                }
            }
            Loader {
                id: notifImageAppIconLoader
                active: root.appIcon != ""
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                sourceComponent: IconImage {
                    implicitSize: root.smallAppIconSize
                    asynchronous: true
                    source: Quickshell.iconPath(root.appIcon, "image-missing")
                }
            }
        }
    }
}