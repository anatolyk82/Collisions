import VPlay 2.0
import QtQuick 2.4

EntityBase {
    id: bonus

    entityType: "bonusType"

    property alias sizeBox: bonusCollider.width
    property alias body: bonusCollider.body
    property alias sourceImage: imageBonus.source

    signal contactWithUsersBall( string entityId )

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

        fixture.onBeginContact: {
            var body = other.getBody();
            var collidedEntity = body.target;
            var collidedEntityType = collidedEntity.entityType;
            if( collidedEntityType == "usersBallType" ) {
                bonus.contactWithUsersBall( entityId )
            }
        }
    }

}
