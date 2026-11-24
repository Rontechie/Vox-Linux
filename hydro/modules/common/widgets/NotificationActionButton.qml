import qs.modules.common
import qs.services
import QtQuick
import Quickshell.Services.Notifications

RippleButton {
    id: button
    property string buttonText
    property string urgency
    readonly property bool critical: urgency == NotificationUrgency.Critical
    readonly property color tint: Appearance.colors.colPrimary

    implicitHeight: 36
    leftPadding: 14
    rightPadding: 14
    buttonRadius: Appearance.rounding.full
    buttonRadiusPressed: Appearance.rounding.small
    colBackground: "transparent"
    colBackgroundHover: Qt.rgba(tint.r, tint.g, tint.b, 0.12)
    colRipple: Qt.rgba(tint.r, tint.g, tint.b, 0.22)

    contentItem: StyledText {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: buttonText
        font.weight: Font.Medium
        color: critical ? Appearance.colors.colPrimary : Appearance.colors.colSubtext
    }
}
