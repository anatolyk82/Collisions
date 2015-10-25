import QtQuick 2.4
import VPlay 2.0

BonusEntity {
    id: medPack

    entityType: "medpackType"

    //how much heath a medical pack adds to the user's ball
    property int health: 20

    sourceImage: "../../assets/img/medpack.png"
}
