import QtQuick
import qs.modules.common.widgets

Row {
    id: eh
    property string key: ""
    property string text: ""
    property real fontSize: 12
    property real shapeSize: 16
    spacing: 8
    MaterialShape {
        anchors.verticalCenter: parent.verticalCenter
        implicitSize: eh.shapeSize
        shape: MaterialShape.Shape.Cookie9Sided
        color: HwM3.alpha(HwPal.muted, 0.5)
    }
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: eh.text
        font.family: HwState.fontSecondary
        font.pixelSize: eh.fontSize
        color: HwPal.muted
    }
}
