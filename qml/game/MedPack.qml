import QtQuick 2.4

BonusEntity {
    id: medPack

    entityType: "medPackType"

    //how much heath a medical pack adds to the user's ball
    property int health: 20

    sourceImage: "../../assets/buttons/button_empty_yellow.png"
}
