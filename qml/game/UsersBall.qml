import VPlay 2.0
import QtQuick 2.5

EntityBaseDraggable {
    id: usersBall

    entityType: "usersBallType"

    property alias radius: ballCollider.radius
    property alias body: ballCollider.body

    draggingAllowed: true
    selectionMouseArea.anchors.fill: padding
    selectionMouseArea.drag.minimumX: 0
    selectionMouseArea.drag.maximumX: parent.width - 2*usersBall.radius
    selectionMouseArea.drag.minimumY: 0
    selectionMouseArea.drag.maximumY: parent.height - 2*usersBall.radius



    dragOffset: Qt.point(-1,-1)

    MultiResolutionImage {
        id: padding
        x:ballCollider.x
        y:ballCollider.y
        width: ballCollider.radius*2
        height: width
        source: "../../assets/img/usersBall.png"
        antialiasing: true
    }

    CircleCollider {
        id: ballCollider
        radius: 20
        width: usersBall.radius
        height: usersBall.radius
        anchors.centerIn: parent

        bodyType: Body.Static
        density: 0
        friction: 0
        restitution: 1

        fixture.onBeginContact: {
            console.log("rrr")
        }
    }

}
