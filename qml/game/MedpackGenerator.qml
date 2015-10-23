import QtQuick 2.4

Item {
    id: generator

    property int probabilityMedpack: 20  //probability of generating a medpack is "probabilityMedpack" percent
    property int sizeMedpack: 30         //size of medpack
    property int health: 20              //how much health a medpack gives the user's ball

    function start() {
        timerGenerator.start()
    }

    function stop() {
        timerGenerator.stop()
    }

    Timer {
        id: timerGenerator
        repeat: true
        interval: 1000
        onTriggered: {
            var randomValue = Math.round( utils.generateRandomValueBetween(0,100) )
            if( (randomValue >= 0) && (randomValue <= probabilityMedpack) ) {

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

                entityManager.createEntityFromUrlWithProperties( Qt.resolvedUrl("MedPack.qml"),
                                                                { x: packX, y: packY, sizeBox: sizeMedpack, health: health} )
            }
        }
    }
}

