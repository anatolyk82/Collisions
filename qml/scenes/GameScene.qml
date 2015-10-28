import QtQuick 2.4
import VPlay 2.0
import "../common"
import "../game"

/*!
  \qmltype GameScene
  \inherits BaseScene
  \brief This scene shows the game field.
*/


BaseScene {
    id: gameScene

    /*--- level settings ---*/
    /*!
      \qmlproperty int GameScene::levelIndex
      \brief The index of current level.
     */
    property int levelIndex: 0

    /*!
      \qmlproperty int GameScene::currentLevel
      \brief The number of current level.
     */
    property int currentLevel: 1

    /*!
      \qmlproperty int GameScene::currentStars
      \brief The current amount of stars which were granted for this level.
     */
    property int currentStars: 0

    /*!
      \qmlproperty int GameScene::totalTime
      \brief The total amount of milliseconds which the timer has to count down.
     */
    property alias totalTime: gameTimer.gameMillisecondsTotal

    /*!
      \qmlproperty int GameScene::periodOfBalls
      \brief The interval in milliseconds between generating of balls.
     */
    property alias periodOfBalls: ballGenerator.intervalBetweenBalls

    /*!
      \qmlproperty int GameScene::timePreparation
      \brief The interval in milliseconds to show the user where a new ball is going to appear.
     */
    property alias timePreparation: ballGenerator.preparatoryInterval

    /*!
      \qmlproperty int GameScene::ballDamage
      \brief How many health points a ball takes away.
     */
    property alias ballDamage: ballGenerator.ballDamage

    /*!
      \qmlproperty int GameScene::ballImpulse
      \brief The amplitude of the impulse applying to a ball when it appears.
     */
    property alias ballImpulse: ballGenerator.ballImpulse

    /*!
      \qmlproperty int GameScene::ballImpulseAdditional
      \brief An additional amplitude of the impulse applying to a ball when it appears.
      A new value is generated in the range from 0 to \a ballImpulseAdditional and it adds to \a ballImpulse.
     */
    property alias ballImpulseAdditional: ballGenerator.ballImpulseAdditional

    /*!
      \qmlproperty int GameScene::medpackProbability
      \brief Probability of generating a medpack on the game field.
      The value should be between 0 and 100. Higher values are ignored.
     */
    property alias medpackProbability: medpackGenerator.medpackProbability

    /*!
      \qmlproperty int GameScene::medpackHealth
      \brief How many health points a medpack gives.
     */
    property alias medpackHealth: medpackGenerator.health

    /*!
      \qmlproperty int GameScene::usersBallSize
      \brief The size of the user's ball.
     */
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

    /*!
      \qmlmethod void GameScene::start()
      It starts the game.
     */
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

    /*!
      \qmlmethod void GameScene::pause( bool isPaused )
      It pauses the game.
     */
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

    /*!
      \qmlmethod void GameScene::stop()
      It stops the game.
     */
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
    /*!
      \qmlmethod void GameScene::currentHealthChangedSlot()
      It is called whenever the user's ball changes its health.
     */
    function currentHealthChangedSlot() {
        barHealth.value = entityManager.getEntityById("usersBall").currentHealth
        //if the ball doesn't have health anomore, stop the game
        if( barHealth.value <= 0 ) {
            gameScene.pause(true)
            dialogGameOver.open()
            buttonPause.visible = false
        }
    }


    /*!
      \qmlmethod int GameScene::grantStarsForCurrentLevel()
      It grants the user starts when the user finishes a level.
      It depends how much health the user's ball has when a level is done.
      \list
       \li 3 stars: 75 - 100 health points
       \li 2 stars: 36 - 74 health points
       \li 1 star: 1- 35 health points
      \endlist
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


    /*!
      \qmlmethod void GameScene::initGame( int index )
      It is called whenever a level changes. It takes settings from the XML and initializes all game properties.
      \a index - an index of current level in the level model.
     */
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

