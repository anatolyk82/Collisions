import VPlay 2.0
import QtQuick 2.5

EntityBaseDraggable {
    id: usersBall

    entityType: "usersBallType"

    draggingAllowed: true
    selectionMouseArea.anchors.fill: padding
    selectionMouseArea.drag.minimumX: guiSettings.wallWidthLeft
    selectionMouseArea.drag.maximumX: usersBall.parent.width - guiSettings.wallWidthLeft - guiSettings.wallWidthRight - usersBall.radius
    selectionMouseArea.drag.minimumY: guiSettings.wallWidthTop
    selectionMouseArea.drag.maximumY: usersBall.parent.height - guiSettings.wallWidthTop - guiSettings.wallWidthBottom - usersBall.radius



    dragOffset: Qt.point(0,0)

    property alias radius: boxCollider.radius

    Rectangle {
        id: padding
        width: boxCollider.radius*2
        height: width
        radius: width/2
        color: "blue"
    }

    CircleCollider {
        id: boxCollider
        radius: 20
        anchors.centerIn: parent

        bodyType: Body.Static
        density: 0.5
        friction: 0
        restitution: 1

        fixture.onBeginContact: {
            console.log("rrr")
        }
    }

}
