import VPlay 2.0
import QtQuick 2.4

EntityBase {
    id: bonus

    entityType: "bonusType"

    property alias sizeBox: bonusCollider.width
    property alias body: bonusCollider.body

    property double impulseX
    property double impulseY

    //this signal emits whenever a user touches a bonus box
    signal bonusHasTouchedByUser()

    //this signal emits whenever a ball touches a bonus box
    //it can be used, for instance, for destroying the bonus by other balls
    signal bonusHasTouchedByBall()

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
            var body = other.getBody();
            var collidedEntity = body.target;
            var collidedEntityType = collidedEntity.entityType;
            if( collidedEntityType == "usersBallType" ) {
                bonus.bonusHasTouchedByUser()
            } else if( collidedEntityType == "usersBallType" ) {
                bonus.bonusHasTouchedByBall()
            }
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
