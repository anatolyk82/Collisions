import VPlay 2.0
import QtQuick 2.5

/*!
  \qmltype UsersBall
  \inherits EntityBase
  \brief A physics object on the game scene represented as a ball. The main characted of the game.
*/


EntityBase {
    id: ball
    z: 5

    entityId: "usersBall"
    entityType: "usersBallType"

    /*!
      \qmlproperty int UsersBall::radius
      \brief The radius of the ball.
     */
    property alias radius: ballCollider.radius

    /*!
      \qmlproperty alias UsersBall::body
      \brief This alias allows access to the physics Body of the ball.
     */
    property alias body: ballCollider.body

    /*!
      \qmlproperty int UsersBall::totalHealth
      \brief This property holds the maximum value of health points the user's ball has.
      The default value is 100
     */
    property int totalHealth: 100

    /*!
      \qmlproperty int UsersBall::currentHealth
      \brief This property holds how many health points the user's ball has.
      The default value is \a totalHealth
     */
    property int currentHealth: totalHealth


    /*!
      \qmlproperty int Ball::damage
      \brief How much health the user's ball takes away
     */
    property int damage: 50


    /*!
      \qmlproperty int UsersBall::__currentHealthPrev
     */
    property int __currentHealthPrev: totalHealth
    onCurrentHealthChanged: {
        currentHealth = currentHealth < 0 ? 0 : ((currentHealth > totalHealth) ? totalHealth : currentHealth)
    }

    Image {
        id: ballImage
        source: {
            if( currentHealth > 85 ) {
                "../../assets/img/usersBall.png"
            } else if( currentHealth > 70 ) {
                "../../assets/img/usersBall_85_70.png"
            } else if( currentHealth > 50 ) {
                "../../assets/img/usersBall_70_50.png"
            } else if( currentHealth > 35 ) {
                "../../assets/img/usersBall_50_35.png"
            } else if( currentHealth > 20 ) {
                "../../assets/img/usersBall_35_20.png"
            } else {
                "../../assets/img/usersBall_20_0.png"
            }
        }
        x: ballCollider.x
        y: ballCollider.y
        width: radius*2
        height: width
        onSourceChanged: {
            if( currentHealth < __currentHealthPrev ) {
                playSound("../../assets/sounds/crack.wav")
            }
            __currentHealthPrev = currentHealth
        }
    }

    CircleCollider {
        id: ballCollider
        radius: 30
        anchors.centerIn: parent

        density: 10
        friction: 0
        restitution: 1
        bodyType: Body.Dynamic

        fixture.onBeginContact: {
            var body = other.getBody();
            var collidedEntity = body.target;
            var collidedEntityType = collidedEntity.entityType;
            if( collidedEntityType == "ballType" ) {
                currentHealth -= collidedEntity.damage
                playSound("../../assets/sounds/usersBallOnBall.wav")
            } else if( collidedEntityType == "medpackType" ) {
                currentHealth += collidedEntity.health
                playSound("../../assets/sounds/medpackTaken.wav")
            } else if( collidedEntityType == "wallType" ) {
                playSound("../../assets/sounds/ballOnWall.wav")
            }
        }
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
      \qmlmethod void UsersBall::playSound( url file )
      It plays sounds for the the user's ball.
     */
    function playSound( file ) {
        var snd = componentSounds.createObject(ball, {"source": file});
        if (snd == null) {
            console.log("Error creating sound");
        } else {
            snd.play()
        }
    }

}

