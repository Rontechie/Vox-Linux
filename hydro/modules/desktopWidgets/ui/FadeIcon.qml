import QtQuick

Text {
    id: fi
    Behavior on text {
        SequentialAnimation {
            NumberAnimation { target: fi; property: "opacity"; to: 0; duration: 80 }
            PropertyAction {}
            NumberAnimation { target: fi; property: "opacity"; to: 1; duration: 140 }
        }
    }
}
