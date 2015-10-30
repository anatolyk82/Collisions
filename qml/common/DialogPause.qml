import QtQuick 2.4
import VPlay 2.0

/*!
  \qmltype DialogPause
  \inherits MultiResolutionImage
  \brief This dialog is shown when the user pauses the game.
*/

MultiResolutionImage {
    id: imageDialogPause
    z: 10
    visible: false
    smooth: true
    antialiasing: true
    anchors.centerIn: parent
    source: "../../assets/dialogs/dialog_simple.png"
    height: app.portrait ? parent.width*0.8 : parent.height*0.7
    width: app.portrait ? parent.width*0.7 : parent.width*0.4

    /*!
      \qmlsignal void DialogPause::resumeClicked()
      \brief This signal is emitted when the button "Resume" is clicked.
     */
    signal resumeClicked()

    /*!
      \qmlsignal void DialogPause::restartClicked()
      \brief This signal is emitted when the button "Restart" is clicked.
     */
    signal restartClicked()

    Column {
        spacing: 5
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 16
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.horizontalCenterOffset: app.portrait ? 0 : 0
            spacing: app.portrait ? 20 : 30
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

    /*!
      \qmlmethod void DialogPause::open()

      It shows the dialog to the user.
     */
    function open() {
        soundPause.play()
        imageDialogPause.visible = true
    }

    /*!
      \qmlmethod void DialogPause::close()

      It closes the dialog.
     */
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


