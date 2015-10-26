import QtQuick 2.4
import VPlay 2.0

Item {
    id: generator

    property int medpackProbability: 20  //probability of generating a medpack is "medpackProbability" percent
    property int sizeMedpack: 30         //size of medpack
    property int health: 20              //how much health a medpack gives the user's ball

    function start() {
        timerGenerator.start()
    }

    function stop() {
        timerGenerator.stop()
    }

    property int _medpackUniqueId: 0   //helps to generate a medpack with a unique Id
    Timer {
        id: timerGenerator
        repeat: true
        interval: 5000
        onTriggered: {
            var randomValue = Math.round( utils.generateRandomValueBetween(1,100) )
            if( (randomValue > 0) && (randomValue <= medpackProbability) ) {
                _medpackUniqueId += 1

                //for X
                var packX = Math.random()*generator.parent.width
                if( packX < 2*sizeMedpack ) {
                    packX += 2*sizeMedpack
                } else if( packX > (generator.parent.width - 2*sizeMedpack)) {
                    packX -= 2*sizeMedpack
                }

                //for Y
                var packY = Math.random()*generator.parent.height
                if( packY < 2*sizeMedpack ) {
                    packY += 2*sizeMedpack
                } else if( packY > (generator.parent.height - 2*sizeMedpack)) {
                    packY -= 2*sizeMedpack
                }

                var medpackId = "medpackId" + _medpackUniqueId
                entityManager.createEntityFromUrlWithProperties( Qt.resolvedUrl("MedPack.qml"),
                              { entityId: medpackId, x: packX, y: packY, sizeBox: sizeMedpack, health: health} )

                var medpackObject = entityManager.getEntityById( medpackId )
                medpackObject.contactWithUsersBall.connect( medpackIsBeingTouchedByUser )

                medpackSound.play()
            }
        }
    }

    //this removes a medpack from the world if the medpack is touched by the user
    function medpackIsBeingTouchedByUser( entityId ) {
        entityManager.removeEntityById(entityId)
    }

    SoundEffectVPlay {
        id: medpackSound
        source: "../../assets/sounds/medpackAppeared.wav"
    }
}

