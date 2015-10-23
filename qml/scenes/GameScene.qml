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
        onClicked: { dialogPause.open() }
    }

    DialogPause {
        id: dialogPause
    }

    Label {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Level") + ":" + currentLevel
    }


    PhysicsWorld {
        id: world
        gravity: Qt.point(0,0)
        running: gameScene.running
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
            id: generator
        }
    }

    onRunningChanged: {
        if( running ) generator.start()
    }

    Component.onCompleted: {
        dialogPause.close()
        entityManager.entityContainer = gameScene //TODO: not here
    }
}

