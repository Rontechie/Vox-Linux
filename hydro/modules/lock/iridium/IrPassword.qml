import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.panels.lock

Item {
    id: root
    required property LockContext context
    property bool busy: false
    property bool failed: false
    property alias input: input
    signal submit()
    signal typed()

    implicitWidth: 400
    implicitHeight: 56

    function shake() { shakeAnim.restart(); }
    property real shakeX: 0
    SequentialAnimation {
        id: shakeAnim
        NumberAnimation { target: root; property: "shakeX"; to: -14; duration: 60 }
        NumberAnimation { target: root; property: "shakeX"; to: 14; duration: 60 }
        NumberAnimation { target: root; property: "shakeX"; to: -9; duration: 50 }
        NumberAnimation { target: root; property: "shakeX"; to: 9; duration: 50 }
        NumberAnimation { target: root; property: "shakeX"; to: 0; duration: 40 }
    }

    Rectangle {
        id: pill
        x: root.shakeX
        width: parent.width
        height: parent.height
        radius: height / 2
        color: root.failed ? Qt.rgba(Appearance.m3colors.m3error.r, Appearance.m3colors.m3error.g, Appearance.m3colors.m3error.b, 0.22)
                           : Appearance.colors.colSecondaryContainer
        border.width: root.busy || root.failed || input.activeFocus ? 1.5 : 0
        border.color: root.failed ? Appearance.m3colors.m3error : Appearance.colors.colPrimary
        Behavior on color { ColorAnimation { duration: 160 } }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 8
            spacing: 10

            MaterialSymbol {
                text: root.failed ? "lock_reset" : "key"
                iconSize: 20
                color: root.failed ? Appearance.m3colors.m3error : Appearance.colors.colOnSecondaryContainer
            }

            Item {
                id: field
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                TextInput {
                    id: input
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    focus: true
                    echoMode: TextInput.Password
                    passwordCharacter: "●"
                    opacity: 0 // the shapes below are the visible feedback
                    enabled: !root.busy
                    inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                    onTextChanged: { root.typed(); if (root.context.currentText !== text) root.context.currentText = text; }
                    onAccepted: root.submit()
                    Keys.onEscapePressed: root.context.reset()
                    Binding { target: input; property: "text"; value: root.context.currentText }
                }

                Row {
                    id: shapes
                    anchors.verticalCenter: parent.verticalCenter
                    x: Math.min(0, field.width - width - 4)
                    spacing: 4
                    Behavior on x { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                    Repeater {
                        model: root.context.currentText.length
                        delegate: MaterialShape {
                            required property int index
                            readonly property var pool: [
                                MaterialShape.Shape.Cookie9Sided, MaterialShape.Shape.Clover4Leaf,
                                MaterialShape.Shape.Flower, MaterialShape.Shape.SoftBurst,
                                MaterialShape.Shape.Pentagon, MaterialShape.Shape.Cookie7Sided
                            ]
                            shape: pool[index % pool.length]
                            implicitSize: 18
                            color: Appearance.colors.colPrimary
                            scale: 0.2
                            Component.onCompleted: scale = 1
                            Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }
                        }
                    }
                    Rectangle { // caret
                        visible: input.activeFocus && !root.busy
                        anchors.verticalCenter: parent.verticalCenter
                        width: 2; height: 18; radius: 1
                        color: Appearance.colors.colPrimary
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            running: input.activeFocus
                            NumberAnimation { to: 0; duration: 520 }
                            NumberAnimation { to: 1; duration: 520 }
                        }
                    }
                }

                StyledText {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: root.context.currentText.length === 0
                    text: root.failed ? Translation.tr("Incorrect password")
                        : root.busy ? Translation.tr("Verifying…")
                        : Translation.tr("Type your password…")
                    font.pixelSize: Appearance.font.pixelSize.normal
                    color: root.failed ? Appearance.m3colors.m3error : Appearance.colors.colOnSecondaryContainer
                    opacity: 0.8
                }
            }

            Rectangle { // unlock
                id: go
                implicitWidth: 42
                implicitHeight: 42
                radius: goArea.pressed ? 12 : 21
                Behavior on radius { NumberAnimation { duration: 160 } }
                readonly property bool ready: !root.busy && root.context.currentText.length > 0
                color: ready ? Appearance.colors.colPrimary : Qt.rgba(1, 1, 1, 0.12)
                Behavior on color { ColorAnimation { duration: 140 } }
                MaterialSymbol {
                    anchors.centerIn: parent
                    text: root.busy ? "progress_activity" : "arrow_forward"
                    iconSize: 22
                    color: go.ready ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSecondaryContainer
                    RotationAnimator on rotation { running: root.busy; from: 0; to: 360; duration: 900; loops: Animation.Infinite }
                }
                MouseArea {
                    id: goArea
                    anchors.fill: parent
                    enabled: go.ready
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.submit()
                }
            }
        }
    }
}
