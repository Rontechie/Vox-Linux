import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

RippleButton {
    id: root
    property string symbol
    property string caption
    property bool selected: false

    toggled: selected
    buttonRadius: Appearance.rounding.full
    implicitHeight: 34
    implicitWidth: row.implicitWidth + 28
    colBackground: Appearance.colors.colLayer1
    colBackgroundToggled: Appearance.colors.colSecondaryContainer
    colBackgroundToggledHover: Appearance.colors.colSecondaryContainerHover

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6
        MaterialSymbol {
            text: root.symbol
            fill: root.selected ? 1 : 0
            iconSize: Appearance.font.pixelSize.larger
            color: root.selected ? Appearance.m3colors.m3onSecondaryContainer : Appearance.colors.colOnLayer1
        }
        StyledText {
            text: root.caption
            color: root.selected ? Appearance.m3colors.m3onSecondaryContainer : Appearance.colors.colOnLayer1
        }
    }
}
