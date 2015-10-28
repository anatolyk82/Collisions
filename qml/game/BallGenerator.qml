import QtQuick 2.4
import VPlay 2.0

/*!
  \qmltype BallGenerator
  \inherits Item
  \brief A invisible game object on the game scene for generating of balls.
*/

Item {
    id: generator

    /* configuring of the generator */

    /*!
      \qmlproperty int BallGenerator::intervalBetweenBalls
      \brief The interval in milliseconds between generating of balls.
     */
    property int intervalBetweenBalls: 10000

    /*!
      \qmlproperty int BallGenerator::preparatoryInterval
      \brief The interval in milliseconds to show the user where a new ball is going to appear.
     */
    property int preparatoryInterval: 3000

    /*!
      \qmlproperty int BallGenerator::ballSize
      \brief The size of ball.
     */
    property int ballSize: 15

    /*!
      \qmlproperty int BallGenerator::ballImpulse
      \brief The amplitude of the impulse applying to a ball when it appears.
     */
    property int ballImpulse: 200

    /*!
      \qmlproperty int BallGenerator::ballImpulseAdditional
      \brief An additional amplitude of the impulse applying to a ball when it appears.
      A new value is generated in the range from 0 to \a ballImpulseAdditional and it adds to \a ballImpulse.
     */
    property int ballImpulseAdditional: 300

    /*!
      \qmlproperty int BallGenerator::ballDamage
      \brief How many health points a ball takes away.
     */
    property int ballDamage: 10

    /*!
      \qmlproperty bool BallGenerator::running
      \brief Whether the generator is working.
     */
    property bool running: true

    /* internall properties */
    /*!
      \qmlproperty real BallGenerator::ballX
     */
    property real ballX: 0.0

    /*!
      \qmlproperty real BallGenerator::ballY
     */
    property real ballY: 0.0

    /*!
      \qmlproperty string BallGenerator::generatedParticlesId
     */
    property string generatedParticlesId: ""

    /*!
      \qmlmethod void BallGenerator::start()
      It starts the generator.
     */
    function start() {
        //fix a new position of a future ball
        generateNewPosotion()

        spriteAppearance.running = true

        //start counting of the preparatory interval
        timerPrepareAppearance.start()
    }

    /*!
      \qmlmethod void BallGenerator::stop()
      It stops the generator.
     */
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


    /*!
      \qmlmethod void BallGenerator::generateNewPosotion()
      It generates a new position on the game field.
     */
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

