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
                starSound1.play()
            } else if( __starsCurrent == 2 ) {
                imageDialogGameEnded.source = "../../assets/dialogs/dialog_level_complete_2.png"
                starSound2.play()
            } else if( __starsCurrent == 3 ) {
                imageDialogGameEnded.source = "../../assets/dialogs/dialog_level_complete_3.png"
                starSound3.play()
            }

            if( __starsCurrent != __starsTotal) {
                timerOfStars.start()
            }
        }
    }


    SoundEffectVPlay {
        id: starSound1
        source: "../../assets/sounds/star.wav"
    }
    SoundEffectVPlay {
        id: starSound2
        source: "../../assets/sounds/star.wav"
    }
    SoundEffectVPlay {
        id: starSound3
        source: "../../assets/sounds/star.wav"
    }
}
