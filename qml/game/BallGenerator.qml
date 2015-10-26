import QtQuick 2.4
import VPlay 2.0

/*
 * This generator creates balls on the game field
 *
 */

Item {
    id: generator

    /* configuring of the generator */
    property int intervalBetweenBalls: 10000
    property int preparatoryInterval: 3000
    property int ballSize: 15       //size of a generating ball
    property int ballImpulse: 200
    property int ballImpulseAdditional: 300
    property int ballDamage: 10

    property bool running: true     //whether the generator is working

    /* internall properties */
    property real ballX: 0.0
    property real ballY: 0.0
    property string generatedParticlesId: ""

    function start() {
        //fix a new position of a future ball
        generateNewPosotion()

        spriteAppearance.running = true

        //start counting of the preparatory interval
        timerPrepareAppearance.start()
    }

    function stop() {
        timerIntervalBetweenBalls.stop()
        timerPrepareAppearance.stop()
        spriteAppearance.running = false
    }


    Timer {
        id: timerPrepareAppearance
        interval: generator.preparatoryInterval
        triggeredOnStart: false
        repeat: false
        //running: generator.running
        onTriggered: {
            //time to create a ball
            //remove the particle system
            spriteAppearance.running = false

            //calculate an impulse for the ball
            var angle = Math.round( Math.random()*360 )
            var impulse = generator.ballImpulse + Math.random()*generator.ballImpulseAdditional
            var impulseX = impulse * Math.cos(angle * Math.PI / 180);
            var impulseY = impulse * Math.sin(angle * Math.PI / 180);

            //entityManager.createEntityFromComponentWithProperties(
            entityManager.createEntityFromUrlWithProperties(
                        Qt.resolvedUrl("Ball.qml"),
                        {
                            x: ballX,
                            y: ballY,
                            radius: generator.ballSize,
                            impulseX: impulseX,
                            impulseY: impulseY,
                            damage: ballDamage
                        }
                        )

            //count the nex interval for a ball
            timerIntervalBetweenBalls.start()
        }
    }



    /* This timer counts the interval between two balls minus the preparatory interval */
    Timer {
        id: timerIntervalBetweenBalls
        interval: (generator.intervalBetweenBalls - generator.preparatoryInterval)
        repeat: false
        onTriggered: {
            generator.start()
        }
    }


    function generateNewPosotion() {
        //a ball shouldn't appear on a wall
        //for X coordinate
        ballX = Math.random()*generator.parent.width
        if( ballX < 2*ballSize ) {
            ballX += 2*ballSize
        } else if( ballX > (generator.parent.width - 2*ballSize)) {
            ballX -= 2*ballSize
        }

        //for Y
        ballY = Math.random()*generator.parent.height
        if( ballY < 2*ballSize ) {
            ballY += 2*ballSize
        } else if( ballY > (generator.parent.height - 2*ballSize)) {
            ballY -= 2*ballSize
        }
        //console.log("a new ball will be created at X:"+ballX+" Y:"+ballY)
    }


    AnimatedSpriteVPlay {
        id: spriteAppearance
        width: 4*generator.ballSize
        height: 4*generator.ballSize
        x: ballX - generator.ballSize
        y: ballY - generator.ballSize
        frameCount: 16
        frameWidth: 128
        frameHeight: 128
        source: "../../assets/img/ballAppearance.png"
        running: false
        visible: running
    }
}

