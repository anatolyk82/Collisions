import QtQuick 2.4
import VPlay 2.0

/*!
  \qmltype MedPack
  \inherits BonusEntity
  \brief A physics object on the game scene represented as a medpack. It restores health to the user's ball.
*/


BonusEntity {
    id: medPack

    entityType: "medpackType"

    /*!
      \qmlproperty int Ball::health
      \brief How much health a medical pack adds to the user's ball
     */
    property int health: 20

    sourceImage: "../../assets/img/medpack.png"
}
