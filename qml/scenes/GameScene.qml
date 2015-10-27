import QtQuick 2.4
import VPlay 2.0
import "../common"
import "../game"

BaseScene {
    id: gameScene

    /*--- level settings ---*/
    property int levelIndex: 0  //index of this current level in the ListModel
    property int currentLevel: 1
    property int currentStars: 0
    property alias totalTime: gameTimer.gameMillisecondsTotal

    property alias periodOfBalls: ballGenerator.intervalBetweenBalls
    property alias timePreparation: ballGenerator.preparatoryInterval
    property alias ballDamage: ballGenerator.ballDamage
    property alias ballImpulse: ballGenerator.ballImpulse
    property alias ballImpulseAdditional: ballGenerator.ballImpulseAdditional

    property alias medpackProbability: medpackGenerator.medpackProbability
    property alias medpackHealth: medpackGenerator.health


    property int usersBallSize: 30

    //we do not need to see the header and button text
    backText: ""
    headerText: ""

    buttonBack.imageSource: "../../assets/buttons/button_grid_blue.png"
    buttonBack.imageSourcePressed: "../../assets/buttons/button_grid_yellow.png"

    MenuButton {
        id: buttonPause
        z: 2
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        width: height
        text: ""
        imageSource: "../../assets/buttons/button_pause_blue.png"
        imageSourcePressed: "../../assets/buttons/button_pause_yellow.png"
        soundEnabled: false
        onClicked: {
            gameScene.pause( true )
            dialogPause.open()
        }
    }

    onBackButtonPressed: {
        gameScene.stop()
        dialogPause.close()
        dialogGameOver.close()
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

    DialogGameEnded {
        id: dialogGameEnded
        z: 12
        onNextClicked: {
            gameScene.stop()
            if( levelIndex == (levelModel.count-1) ) {
                gameScene.backButtonPressed()
            } else {
                levelIndex = levelIndex + 1
                initGame( levelIndex )
                gameScene.start()
            }
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

        gameMillisecondsTotal: 30000
        onTimerIsOver: {
            //stop the game
            buttonPause.visible = false
            gameScene.pause( true )

            //get stars for this level
            var stars = grantStarsForCurrentLevel()

            //save the result if it's better
            var key = "level"+currentLevel
            if( stars > gameScene.currentStars ) {
                myLocalStorage.setValue( key, stars )
            }
            dialogGameEnded.open( stars )

            //change the level model
            initAllLevels()
        }
    }


    PhysicsWorld {
        id: world
        gravity: Qt.point(0,0)
        running: false
        debugDrawVisible: false

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
            medpackProbability: 60
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
        //close all previous dialogs
        dialogGameEnded.close()
        dialogPause.close()
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
        //start timer
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


    /*
     * 3 stars: 75 - 100 health points
     * 2 stars: 36 - 74 health points
     * 1 star: 1- 35 health points
     */
    function grantStarsForCurrentLevel() {
        if( barHealth.value >= 75 ) {
            return 3
        } else if(barHealth.value > 35) {
            return 2
        } else {
            return 1
        }
    }


    function initGame( index ) {
        gameScene.levelIndex = index
        gameScene.currentLevel = levelModel.get(index).level
        gameScene.currentStars = levelModel.get(index).stars
        gameScene.totalTime = levelModel.get(index).totalTime
        gameScene.periodOfBalls = levelModel.get(index).periodOfBalls
        gameScene.timePreparation = levelModel.get(index).timePreparation
        gameScene.medpackProbability = levelModel.get(index).medpackProbability
        gameScene.medpackHealth = levelModel.get(index).medpackHealth
        gameScene.ballDamage = levelModel.get(index).ballDamage
        gameScene.ballImpulse = levelModel.get(index).ballImpulse
        gameScene.ballImpulseAdditional = levelModel.get(index).ballImpulseAdditional
    }


    Component.onCompleted: {
        dialogPause.close()
        entityManager.entityContainer = gameScene //TODO: not here
    }
}

