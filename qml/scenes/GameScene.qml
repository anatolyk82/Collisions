import QtQuick 2.4
import VPlay 2.0
import "../common"
import "../game"

BaseScene {
    id: gameScene

    property int currentLevel: 0

    property bool running: false

    property int usersBallSize: 30

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
        z: 10
        onResumeClicked: {
            gameScene.pause( false )
        }
        onRestartClicked: {
            gameScene.stop()
            gameScene.start()
        }
    }

    DialogGameOver {
        id: dialogGameOver
        z: 11
        onMenuClicked: {
            gameScene.backButtonPressed()
        }
        onRestartClicked: {
            gameScene.stop()
            gameScene.start()
        }
    }

    Label {
        id: labelOfCurrentLevel
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Level") + ":" + currentLevel
    }

    HealthBar {
        id: barHealth
        z: 10
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
    }

    GameTimer {
        id: gameTimer
        z: 10
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        onTimerIsOver: {
        }
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

        MedpackGenerator {
            id: medpackGenerator
            probabilityMedpack: 60
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
            maxForce:  50000000//world.pixelsPerMetr
            dampingRatio: 0.5 //0-1
            frequencyHz: 1
        }
    }


    /**** manage the game scene ****/

    /* this starts the game */
    function start() {
        //create the user's ball
        entityManager.createEntityFromUrlWithProperties ( Qt.resolvedUrl("../game/UsersBall.qml"),
                      { x: (world.width/2-usersBallSize), y: (world.height/2-usersBallSize), radius: usersBallSize, } )
        //connect signals from the ball
        var usersBallObject = entityManager.getEntityById("usersBall")
        usersBallObject.onCurrentHealthChanged.connect( currentHealthChangedSlot )
        //set the health bar to the maximum value
        barHealth.value = usersBallObject.totalHealth
        barHealth.maxValue = usersBallObject.totalHealth
        barHealth.minValue = 0
        //run the world
        world.running = true
        //start game generators
        ballGenerator.start()
        medpackGenerator.start()
        gameTimer.start()
        buttonPause.visible = true
    }

    /* this function pauses the game */
    function pause( isPaused ) {
        gameTimer.pause( isPaused )
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

    /* this function stops the game */
    function stop() {
        gameTimer.stop()
        medpackGenerator.stop()
        ballGenerator.stop()
        //stop the physic world
        world.running = false
        //remove all balls
        var toRemoveEntityTypes = ["ballType","medpackType","usersBallType"];
        entityManager.removeEntitiesByFilter(toRemoveEntityTypes);
    }

    /* it calls whenever health changes */
    function currentHealthChangedSlot() {
        barHealth.value = entityManager.getEntityById("usersBall").currentHealth
        //if the ball doesn't have health anomore, stop the game
        if( barHealth.value <= 0 ) {
            gameScene.pause(true)
            dialogGameOver.open()
            buttonPause.visible = false
        }
    }


    Component.onCompleted: {
        dialogPause.close()
        entityManager.entityContainer = gameScene //TODO: not here
    }
}

