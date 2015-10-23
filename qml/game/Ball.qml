import VPlay 2.0
import QtQuick 2.3

EntityBase {
    id: ball
    //entityId: "ball"
    //entityType: "ballType"

    property alias radius: ballCollider.radius
    property alias body: ballCollider.body

    property double impulseX
    property double impulseY

    /*AnimatedSpriteVPlay {
        id: sprite
        anchors.fill: ballCollider
        frameCount: 9
        frameWidth: 90
        frameHeight: 90
        source: "../../assets/img/balls.png"
        running: true
    }
    */

    /*Image {
        id: boxImage
        source: "../../assets/img/balls.png"
        anchors.fill: ballCollider
        x:-sprite.width*sprite.frame
    }
    SpriteVPlay {
        id: sprite
        anchors.fill: ballCollider
        duration: 100000
        frameCount: 9
        source: "../../assets/img/balls.png"
        frameWidth: 90
        frameHeight: 90
        //startFrameColumn: Math.random()*3
        //startFrameRow: Math.random()*3
        randomStart: true
    }*/
    Rectangle {
        width: ballCollider.radius*2
        height: width
        radius: width/2
        color: "red"
    }

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

    function pushBall() {
        var localForwardVector = ballCollider.body.toWorldVector(Qt.point(ball.impulseX,ball.impulseY));
        ballCollider.body.applyLinearImpulse( localForwardVector, ballCollider.body.getWorldCenter() );
        console.log("1:Push the ball:"+localForwardVector.x+";"+localForwardVector.y)
    }

    Component.onCompleted: pushBall()
}
