import VPlay 2.0
import QtQuick 2.4

/*!
  \qmltype Wall
  \inherits EntityBase
  \brief A physics object on the game scene represented as a wall.
*/


EntityBase {
    id: wall

    entityType: "wallType"

    Rectangle {
        id: boxImage
        width: parent.width
        height: parent.height
        color: "transparent"
    }

    BoxCollider {
        anchors.fill: boxImage
        bodyType: Body.Static
    }
}
