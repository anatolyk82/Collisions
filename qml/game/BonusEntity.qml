import VPlay 2.0
import QtQuick 2.4

EntityBase {
    id: bonus

    entityType: "bonusType"

    property alias sizeBox: bonusCollider.width
    property alias body: bonusCollider.body
    property alias sourceImage: imageBonus.source

    Image {
        id: imageBonus
        source: ""
        x: bonusCollider.x
        y: bonusCollider.y
        width: sizeBox
        height: sizeBox
    }

    BoxCollider {
        id: bonusCollider

        width: 30
        height: width

        sensor: true

        anchors.centerIn: parent

        density: 0
        friction: 0
        restitution: 1
        bodyType: Body.Dynamic
    }

}
