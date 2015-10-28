import VPlay 2.0
import QtQuick 2.3

/*!
  \qmltype Ball
  \inherits EntityBase
  \brief A physics object on the game scene represented as a ball.
*/


EntityBase {
    id: ball
    z: 1

    entityType: "ballType"

    /*!
      \qmlproperty int Ball::radius
      \brief The radius of the ball.
     */
    property alias radius: ballCollider.radius

    /*!
      \qmlproperty alias Ball::body
      \brief This alias allows access to the physics Body of the ball.
     */
    property alias body: ballCollider.body

    /*!
      \qmlproperty double Ball::impulseX
      \brief X value of the impulse
     */
    property double impulseX

    /*!
      \qmlproperty double Ball::impulseY
      \brief Y value of the impulse
     */
    property double impulseY

    /*!
      \qmlproperty int Ball::damage
      \brief How much health the ball takes away
     */
    property int damage: 10

    CircleCollider {
        id: ballCollider
        anchors.centerIn: parent

        density: 0
        friction: 0
        restitution: 1
        bodyType: Body.Dynamic

        fixture.onBeginContact: {
            var body = other.getBody();
            var collidedEntity = body.target;
            var collidedEntityType = collidedEntity.entityType;
            if( collidedEntityType == "wallType" ) {
                playSound("../../assets/sounds/ballOnWall.wav")
            }
        }
    }

    AnimatedSpriteVPlay {
        id: sprite
        width: 2*ball.radius
        height: 2*ball.radius
        x: ballCollider.x
        y: ballCollider.y
        frameCount: 9
        frameWidth: 90
        frameHeight: 90
        source: "../../assets/img/balls.png"
        running: false
        frameX: Math.round( utils.generateRandomValueBetween(1,8) )*frameWidth
    }


    /*!
      \qmlmethod void Ball::pushBall()
      It pushes the ball when it is created
     */
    function pushBall() {
        var localForwardVector = ballCollider.body.toWorldVector(Qt.point(ball.impulseX,ball.impulseY));
        ballCollider.body.applyLinearImpulse( localForwardVector, ballCollider.body.getWorldCenter() );
    }


    Component {
        id: componentSounds
        SoundEffectVPlay {
            id: soundEffect
            onPlayingChanged: {
                if( playing == false ) {
                    soundEffect.destroy()
                }
            }
        }
    }

    /*!
      \qmlmethod void Ball::playSound( url file )
      It plays sounds for the the ball
     */
    function playSound( file ) {
        var snd = componentSounds.createObject(ball, {"source": file});
        if (snd == null) {
            console.log("Error creating sound");
        } else {
            snd.play()
        }
    }

    Component.onCompleted: {
        pushBall()
    }
}
