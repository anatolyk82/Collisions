import QtQuick 2.4
import VPlay 2.0

/*!
  \qmltype MedpackGenerator
  \inherits Item
  \brief An invisible game object on the game scene for generating of medpacks.
*/


Item {
    id: generator

    /*!
      \qmlproperty int MedpackGenerator::medpackProbability
      \brief Probability of generating a medpack on the game field.
      The value should be between 0 and 100. Higher values are ignored.
     */
    property int medpackProbability: 20

    /*!
      \qmlproperty int MedpackGenerator::sizeMedpack
      \brief The size of medpack.
     */
    property int sizeMedpack: 30

    /*!
      \qmlproperty int MedpackGenerator::health
      \brief How many health points a medpack gives.
     */
    property int health: 20

    /*!
      \qmlmethod void MedpackGenerator::start()
      It starts the generator.
     */
    function start() {
        timerGenerator.start()
    }

    /*!
      \qmlmethod void MedpackGenerator::stop()
      It stops the generator.
     */
    function stop() {
        timerGenerator.stop()
    }

    /*!
      \qmlproperty int MedpackGenerator::_medpackUniqueId
     */
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

    /*!
      \qmlmethod void MedpackGenerator::medpackIsBeingTouchedByUser( string medpackEntityId )
      This slot removes a medpack from the game scene when the user touches it with the ball
     */
    function medpackIsBeingTouchedByUser( medpackEntityId ) {
        entityManager.removeEntityById( medpackEntityId )
    }

    SoundEffectVPlay {
        id: medpackSound
        source: "../../assets/sounds/medpackAppeared.wav"
    }
}

