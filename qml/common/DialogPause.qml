import QtQuick 2.4
import VPlay 2.0



MultiResolutionImage {
    id: imageDialogPause
    z: 10
    visible: false
    smooth: true
    antialiasing: true
    anchors.centerIn: parent
    source: "../../assets/dialogs/dialog_simple.png"
    height: parent.height*0.7
    width: parent.width*0.4

    signal resumeClicked()
    signal restartClicked()

    Column {
        spacing: 5
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 16
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 15
            //spacing: 30
            MenuButton {
                id: buttonMusic
                checkable: true
                imageSource: "../../assets/buttons/button_music_blue.png"
                imageSourcePressed: "../../assets/buttons/button_music_yellow.png"
                imageSourceChecked:  "../../assets/buttons/button_music_grey.png"
                text: ""
                checked: settings.musicEnabled
                onClicked: { settings.musicEnabled = checked }
            }

            MenuButton {
                id: buttonSound
                checkable: true
                imageSource: "../../assets/buttons/button_sound_blue.png"
                imageSourcePressed: "../../assets/buttons/button_sound_yellow.png"
                imageSourceChecked:  "../../assets/buttons/button_sound_grey.png"
                text: ""
                checked: settings.soundEnabled
                onClicked: { settings.soundEnabled = checked }
            }
        }

        MenuButton {
            id: buttonResume
            z: 2
            //anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Resume")
            imageSource: "../../assets/buttons/button_ok_blue.png"
            imageSourcePressed: "../../assets/buttons/button_ok_yellow.png"
            soundEnabled: false
            onClicked: {
                imageDialogPause.close()
                //continue the game
                imageDialogPause.resumeClicked()
                soundUnpause.play()
            }
        }
        MenuButton {
            id: buttonRestart
            z: 2
            //anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Restart")
            imageSource: "../../assets/buttons/button_restart_blue.png"
            imageSourcePressed: "../../assets/buttons/button_restart_yellow.png"
            onClicked: {
                imageDialogPause.close()
                //retsart the game
                imageDialogPause.restartClicked()
            }
        }
    }

    function open() {
        soundPause.play()
        imageDialogPause.visible = true
    }

    function close() {
        imageDialogPause.visible = false
    }

    SoundEffectVPlay {
        id: soundPause
        source: "../../assets/sounds/pause.wav"
    }
    SoundEffectVPlay {
        id: soundUnpause
        source: "../../assets/sounds/unpause.wav"
    }
}


