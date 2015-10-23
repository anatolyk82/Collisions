import VPlay 2.0
import QtQuick 2.3

EntityBase {
    id: ball

    entityType: "ballType"

    property alias radius: ballCollider.radius
    property alias body: ballCollider.body

    property double impulseX
    property double impulseY

    CircleCollider {
        id: ballCollider
        radius: guiSettings.ballSize
        anchors.centerIn: parent

        density: 0
        friction: 0
        restitution: 1
        bodyType: Body.Dynamic

        fixture.onBeginContact: {
            //console.log("Collision")
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
        //console.log("1:Push the ball:"+localForwardVector.x+";"+localForwardVector.y)
    }

    Component.onCompleted: {
        pushBall()
    }
}
