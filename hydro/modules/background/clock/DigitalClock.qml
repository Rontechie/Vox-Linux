import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

ColumnLayout {
    id: root
    readonly property var dig: Config.options.background.widgets.clock.digital
    property color colText: Appearance.colors.colOnLayer0
    property real canvasWidth: 0
    property real clockCenterX: 0

    readonly property int textAlign: !dig.adaptiveAlignment ? Qt.AlignHCenter
        : (clockCenterX < canvasWidth * 0.33 ? Qt.AlignLeft
        : (clockCenterX > canvasWidth * 0.67 ? Qt.AlignRight : Qt.AlignHCenter))
    readonly property var parts: DateTime.time.split(/[:\s]/)
    readonly property var axes: ({ "wght": dig.font.weight, "wdth": dig.font.width, "ROND": dig.font.roundness })

    spacing: -4

    readonly property var sh: Config.options.background.widgets.clock.shadow
    layer.enabled: sh.enable
    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: root.sh.offset
        radius: root.sh.offset * 2 + 4
        samples: Math.round(root.sh.offset * 2 + 4) * 2 + 1
        color: Qt.alpha(Appearance.m3colors.m3shadow, root.sh.opacity)
    }

    component TimeText: StyledText {
        color: root.colText
        font.pixelSize: root.dig.font.size
        font.weight: root.dig.font.weight
        font.family: root.dig.font.family
        font.variableAxes: root.axes
        animateChange: root.dig.animateChange
    }

    TimeText {
        visible: !root.dig.vertical
        Layout.alignment: root.textAlign
        text: DateTime.time
    }
    TimeText {
        visible: root.dig.vertical
        Layout.alignment: root.textAlign
        text: root.parts[0] ?? ""
    }
    TimeText {
        visible: root.dig.vertical
        Layout.alignment: root.textAlign
        text: root.parts[1] ?? ""
    }
    StyledText {
        visible: root.dig.showDate
        Layout.alignment: root.textAlign
        text: DateTime.longDate
        color: root.colText
        font.pixelSize: Appearance.font.pixelSize.larger
    }
}
