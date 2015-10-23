import QtQuick 2.4
import VPlay 2.0
import "../common"
import "../game"

BaseScene {
    id: gameScene

    property int currentLevel: 0

    property bool running: false

    //we do not need to see the header and button text
    backText: ""
    headerText: ""

    MenuButton {
        id: buttonPause
        z: 2
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 5
        text: ""
        imageSource: "../../assets/buttons/button_pause_blue.png"
        imageSourcePressed: "../../assets/buttons/button_pause_yellow.png"
        onClicked: {
            gameScene.pause( true )
            dialogPause.open()
        }
    }

    onBackButtonPressed: {
        gameScene.stop()
        dialogPause.close()
    }

    DialogPause {
        id: dialogPause
        z: 5
        onResumeClicked: {
            gameScene.pause( false )
        }
        onRestartClicked: {
            gameScene.stop()
            gameScene.start()
        }
    }

    Label {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Level") + ":" + currentLevel
    }

    HealthBar {
        id: barHealth
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        //value: usersBall.currentHealth
    }

    PhysicsWorld {
        id: world
        gravity: Qt.point(0,0)
        running: false
        //debugDrawVisible: false

        //walls aren't visible because their edges are at appropriate edges of the screen
        Wall {
            id: bottomWall
            height: 10
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                bottomMargin: -height
            }
        }
        Wall {
            id: topWall
            height: 10
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                topMargin: -height
            }
        }
        Wall {
            id: leftWall
            width: 10
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                leftMargin: -width
            }
        }
        Wall {
            id: rightWall
            width: 10
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                rightMargin: -width
            }
        }

        BallGenerator {
            id: ballGenerator
        }

        UsersBall {
            id: usersBall
            onCurrentHealthChanged: {
                barHealth.value = currentHealth
            }
        }

        MedpackGenerator {
            id: medpackGenerator
            probabilityMedpack: 5
        }


        MouseArea {
            property Body selectedBody: null
            property MouseJoint mouseJointWhileDragging: null

            anchors.fill: parent
            onPressed: {
                selectedBody = world.bodyAt( Qt.point(mouseX, mouseY))
                if( selectedBody ) {
                    //if the user selected a body, create a new MouseJoint
                    //and connect the joint with the body
                    mouseJointWhileDragging = mouseJoint.createObject(world)
                    mouseJointWhileDragging.target = Qt.point(mouseX, mouseY)
                    mouseJointWhileDragging.bodyB = selectedBody
                }
            }
            onPositionChanged: {
                if( mouseJointWhileDragging ) {
                    mouseJointWhileDragging.target = Qt.point(mouseX, mouseY)
                }
            }
            onReleased: {
                //remove the created MouseJoint if the user pressed a body
                if(selectedBody) {
                    selectedBody = null
                    if(mouseJointWhileDragging) {
                        mouseJointWhileDragging.destroy()
                    }
                }
            }
        }
    }

    Component {
        id: mouseJoint
        MouseJoint {
            maxForce:  100000//world.pixelsPerMetr
            dampingRatio: 0.5 //0-1
            frequencyHz: 1
        }
    }


    /**** manage the game scene ****/
    function start() {
        world.running = true
        usersBall.x = world.width/2
        usersBall.y = world.height/2
        ballGenerator.start()
        medpackGenerator.start()
    }

    function pause( isPaused ) {
        if( isPaused ) {
            medpackGenerator.stop()
            ballGenerator.stop()
            world.running = false
        } else {
            medpackGenerator.start()
            ballGenerator.start()
            world.running = true
        }
    }

    function stop() {
        medpackGenerator.stop()
        ballGenerator.stop()
        //stop the physic world
        world.running = false
        //remove all balls
        var toRemoveEntityTypes = ["ballType"];
        entityManager.removeEntitiesByFilter(toRemoveEntityTypes);
    }


    Component.onCompleted: {
        dialogPause.close()
        entityManager.entityContainer = gameScene //TODO: not here
    }
}

