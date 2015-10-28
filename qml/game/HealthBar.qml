import QtQuick 2.4
import "../common"

/*!
  \qmltype HealthBar
  \inherits Item
  \brief A graphic object on the game scene which shows the player the current amount of health points.
*/

Item {
    id: bar

    /*!
      \qmlproperty int HealthBar::maxValue
      \brief The maximum value of health points.
     */
    property int maxValue: 100

    /*!
      \qmlproperty int HealthBar::minValue
      \brief The minimum value of health points.
     */
    property int minValue: 0

    /*!
      \qmlproperty int HealthBar::value
      \brief The current value of health points.
     */
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
            anchors.verticalCenterOffset: -1
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

