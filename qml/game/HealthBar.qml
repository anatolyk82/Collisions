import QtQuick 2.4
import "../common"


Item {
    id: bar
    property int maxValue: 100
    property int minValue: 0
    property int value: 50

    onValueChanged: {
        value = (value < minValue) ? minValue : ( (value > maxValue) ? maxValue : value )
    }

    width: 120
    height: 30

    Image {
        id: img
        source: "../../assets/img/bar_health_empty.png"
        width: parent.width
        height: parent.height

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: bar.width*0.25
            width: maxValue != 0 ? (bar.width - bar.width*0.33)*(value/maxValue) : (bar.width - bar.width*0.33)
            Behavior on width { NumberAnimation { duration: 400 } }
            height: bar.height*0.4
            gradient: Gradient {
                GradientStop { position: 0; color: "#ff3d9a" }
                GradientStop { position: 1; color: "#fe007a" }
            }
        }

        Label {
            anchors.centerIn: parent
            font.pixelSize: parent.height*0.4
            text: value
        }

    }
}

