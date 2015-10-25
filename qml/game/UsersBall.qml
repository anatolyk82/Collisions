import VPlay 2.0
import QtQuick 2.5

EntityBase {
    id: ball
    z: 5

    entityId: "usersBall"
    entityType: "usersBallType"

    property alias radius: ballCollider.radius
    property alias body: ballCollider.body

    /* health points of the user's ball */
    property int totalHealth: 100
    property int currentHealth: totalHealth
    property int __currentHealthPrev: totalHealth
    onCurrentHealthChanged: {
        currentHealth = currentHealth < 0 ? 0 : ((currentHealth > totalHealth) ? totalHealth : currentHealth)
        if( currentHealth < __currentHealthPrev ) {
            playSound("../../assets/sounds/crack.wav")
        }
        __currentHealthPrev = currentHealth
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

    function playSound( file ) {
        var snd = componentSounds.createObject(ball, {"source": file});
        if (snd == null) {
            console.log("Error creating sound");
        } else {
            snd.play()
        }
    }
}

