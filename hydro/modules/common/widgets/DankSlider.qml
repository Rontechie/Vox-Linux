import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property real value: 0
    property real minimum: 0
    property real maximum: 100
    property real step: 1
    property string unit: ""
    property bool showValue: true
    property bool wheelEnabled: true
    property var valueOverride: undefined // show this text instead of the number
    property string leftIcon: ""
    property string rightIcon: ""
    property color trackColor: Appearance.colors.colSecondaryContainer
    property real trackOpacity: 1
    property color thumbOutlineColor: Appearance.colors.colLayer1
    signal sliderValueChanged(int newValue)
    signal sliderDragFinished(int finalValue)

    implicitWidth: 200
    implicitHeight: 32

    RowLayout {
        anchors.fill: parent
        spacing: 10

        MaterialSymbol {
            visible: root.leftIcon !== ""
            text: root.leftIcon
            iconSize: Appearance.font.pixelSize.larger
            color: Appearance.colors.colSubtext
        }

        DankSliderControl {
            id: control
            Layout.fillWidth: true
            from: root.minimum
            to: root.maximum
            stepSize: root.step
            value: root.value
            usePercentTooltip: false
            unit: root.unit
            trackColor: root.trackColor
            trackOpacity: root.trackOpacity
            thumbOutlineColor: root.thumbOutlineColor
            onMoved: root.sliderValueChanged(Math.round(control.value))
            onPressedChanged: if (!pressed) root.sliderDragFinished(Math.round(control.value))

            WheelHandler {
                enabled: root.wheelEnabled
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: event => {
                    const dir = event.angleDelta.y > 0 ? 1 : -1;
                    const nv = Math.max(root.minimum, Math.min(root.maximum, control.value + dir * root.step));
                    if (nv !== control.value) {
                        root.sliderValueChanged(Math.round(nv));
                        root.sliderDragFinished(Math.round(nv));
                    }
                }
            }
        }

        MaterialSymbol {
            visible: root.rightIcon !== ""
            text: root.rightIcon
            iconSize: Appearance.font.pixelSize.larger
            color: Appearance.colors.colSubtext
        }

        StyledText {
            visible: root.showValue
            Layout.minimumWidth: 44
            horizontalAlignment: Text.AlignRight
            font.family: Appearance.font.family.monospace
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.colPrimary
            text: root.valueOverride !== undefined ? String(root.valueOverride) : Math.round(root.value) + root.unit
        }
    }
}
