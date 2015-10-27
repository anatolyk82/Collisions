import QtQuick 2.4
import VPlay 2.0


MultiResolutionImage {
    id: imageDialogGameEnded

    property int __starsTotal: 3
    property int __starsCurrent: 0

    visible: false
    smooth: true
    antialiasing: true
    anchors.centerIn: parent
    source: "../../assets/dialogs/dialog_level_complete_0.png"
    height: parent.height*0.75
    width: parent.width*0.4

    //these let the game know which button was pressed
    signal menuClicked()
    signal restartClicked()
    signal nextClicked()

    Label {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("You won !")
        color: "#f3db95"
    }

    Column {
        spacing: 5
        width: parent.width*0.7
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -5
        anchors.verticalCenterOffset: 50


        MenuButton {
            id: buttonRestart
            z: 2
            text: qsTr("Try again")
            imageSource: "../../assets/buttons/button_restart_blue.png"
            imageSourcePressed: "../../assets/buttons/button_restart_yellow.png"
            onClicked: {
                imageDialogGameEnded.close()
                imageDialogGameEnded.restartClicked()
            }
        }
        MenuButton {
            id: buttonNext
            z: 2
            text: qsTr("Next")
            imageSource: "../../assets/buttons/button_ok_blue.png"
            imageSourcePressed: "../../assets/buttons/button_ok_yellow.png"
            onClicked: {
                imageDialogGameEnded.close()
                imageDialogGameEnded.nextClicked()
            }
        }
    }

    function open( stars ) {
        buttonRestart.enabled = false
        buttonNext.enabled = false
        playSound("../../assets/sounds/gameDone.wav")
        __starsTotal = stars
        imageDialogGameEnded.source = "../../assets/dialogs/dialog_level_complete_0.png"
        imageDialogGameEnded.visible = true
        timerOfStars.start()
    }

    function close() {
        __starsCurrent = 0
        imageDialogGameEnded.visible = false
    }

    Timer {
        id: timerOfStars
        interval: 500
        triggeredOnStart: false
        repeat: false
        onTriggered: {
            __starsCurrent += 1
            if( __starsCurrent == 1 ) {
                imageDialogGameEnded.source = "../../assets/dialogs/dialog_level_complete_1.png"
                playSound("../../assets/sounds/star.wav")
            } else if( __starsCurrent == 2 ) {
                imageDialogGameEnded.source = "../../assets/dialogs/dialog_level_complete_2.png"
                playSound("../../assets/sounds/star.wav")
            } else if( __starsCurrent == 3 ) {
                imageDialogGameEnded.source = "../../assets/dialogs/dialog_level_complete_3.png"
                playSound("../../assets/sounds/star.wav")
            }

            if( __starsCurrent != __starsTotal) {
                timerOfStars.start()
            } else {
                buttonRestart.enabled = true
                buttonNext.enabled = true
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
        var snd = componentSounds.createObject(imageDialogGameEnded, {"source": file});
        if (snd == null) {
            console.log("Error creating sound");
        } else {
            snd.play()
        }
    }
}
