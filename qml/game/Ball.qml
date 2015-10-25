import VPlay 2.0
import QtQuick 2.3

EntityBase {
    id: ball
    z: 1

    entityType: "ballType"

    property alias radius: ballCollider.radius
    property alias body: ballCollider.body

    property double impulseX
    property double impulseY

    /* how many health points this ball takes from the user's ball */
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
