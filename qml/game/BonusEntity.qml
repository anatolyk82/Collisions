import VPlay 2.0
import QtQuick 2.4

/*!
  \qmltype BonusEntity
  \inherits EntityBase
  \brief A physics object on the game scene represented as a bonus item. It doesn't react on collisions.
*/


EntityBase {
    id: bonus

    entityType: "bonusType"

    /*!
      \qmlproperty int BonusEntity::sizeBox
      \brief The size of the bonus item.
     */
    property alias sizeBox: bonusCollider.width

    /*!
      \qmlproperty alias BonusEntity::body
      \brief This property alias allows access to the physics Body of the item.
     */
    property alias body: bonusCollider.body

    /*!
      \qmlproperty url BonusEntity::sourceImage
      \brief The picture of the bonus item.
     */
    property alias sourceImage: imageBonus.source

    /*!
      \qmlsignal void BonusEntity::contactWithUsersBall( string entityId )
      \brief It is emitted when the user's ball contacts with the bonus item.
     */
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
