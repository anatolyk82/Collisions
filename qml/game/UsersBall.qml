import VPlay 2.0
import QtQuick 2.5

EntityBase {
    id: ball

    entityType: "usersBallType"

    property alias radius: ballCollider.radius
    property alias body: ballCollider.body

    Image {
        id: ballImage
        source: "../../assets/img/usersBall.png"
        x: ballCollider.x
        y: ballCollider.y
        width: radius*2
        height: width
    }

    CircleCollider {
        id: ballCollider
        radius: 20
        anchors.centerIn: parent

        density: 0
        friction: 0
        restitution: 1
        bodyType: Body.Dynamic

        fixture.onBeginContact: {
            //console.log("Collision")
        }
    }
}

