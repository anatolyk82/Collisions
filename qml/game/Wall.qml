import VPlay 2.0
import QtQuick 2.4


EntityBase {
    id: wall

    property alias wallColor: boxImage.color

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
