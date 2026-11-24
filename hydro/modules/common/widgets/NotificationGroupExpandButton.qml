import qs.services
import qs.modules.common
import qs.modules.common.functions
import QtQuick
import QtQuick.Layouts

RippleButton { // Expand button
    id: root
    required property int count
    required property bool expanded
    property real fontSize: Appearance?.font.pixelSize.small ?? 12
    property real iconSize: Appearance?.font.pixelSize.normal ?? 16
    implicitHeight: 30
    implicitWidth: root.count > 1 ? Math.max(contentItem.implicitWidth + 16, 44) : 30
    Layout.alignment: Qt.AlignVCenter
    Layout.fillHeight: false

    buttonRadius: Appearance.rounding.full
    colBackground: root.count > 1 ? Appearance.colors.colTertiaryContainer : Appearance.colors.colLayer3
    colBackgroundHover: root.count > 1 ? Appearance.colors.colTertiaryContainerHover : Appearance.colors.colLayer3Hover
    colRipple: root.count > 1 ? Appearance.colors.colTertiaryContainerActive : Appearance.colors.colLayer3Active

    contentItem: Item {
        anchors.centerIn: parent
        implicitWidth: contentRow.implicitWidth
        RowLayout {
            id: contentRow
            anchors.centerIn: parent
            spacing: 3
            StyledText {
                Layout.leftMargin: 4
                visible: root.count > 1
                text: root.count
                font.pixelSize: root.fontSize
                font.weight: Font.Medium
                color: Appearance.colors.colOnTertiaryContainer
            }
            MaterialSymbol {
                text: "keyboard_arrow_down"
                iconSize: root.iconSize
                color: root.count > 1 ? Appearance.colors.colOnTertiaryContainer : Appearance.colors.colOnLayer2
                rotation: expanded ? 180 : 0
                Behavior on rotation {
                    animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                }
            }
        }
    }
}
