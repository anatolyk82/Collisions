import VPlay 2.0
import QtQuick 2.4

EntityBase {
    id: bonus

    entityType: "bonusType"

    property alias sizeBox: bonusCollider.width
    property alias body: bonusCollider.body

    property double impulseX
    property double impulseY

    BoxCollider {
        id: bonusCollider

        width: 20
        height: width

        sensor: true

        anchors.centerIn: parent

        density: 0
        friction: 0
        restitution: 1
        bodyType: Body.Dynamic

        fixture.onBeginContact: {
            console.log("aaa")
        }
    }

    Rectangle {
        id: padding
        width: bonus.sizeBox
        height: width
        color: "red"
        x: bonusCollider.x
        y: bonusCollider.y
    }


}
