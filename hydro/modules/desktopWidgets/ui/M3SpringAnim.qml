import QtQuick

SpringAnimation {
    property string token: "spatialDefault"
    spring: token === "spatialSlow" ? 1.6 : token === "spatialFast" ? 4.5 : 2.8
    damping: token === "spatialSlow" ? 0.26 : token === "spatialFast" ? 0.34 : 0.3
    epsilon: 0.01
}
