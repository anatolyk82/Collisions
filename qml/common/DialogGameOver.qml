import QtQuick 2.4
import VPlay 2.0

/*!
  \qmltype DialogGameOver
  \inherits MultiResolutionImage
  \brief This dialog is shown when the user loses the game.
*/

MultiResolutionImage {
    id: imageDialogGameOver
    z: 20
    visible: false
    smooth: true
    antialiasing: true
    anchors.centerIn: parent
    source: "../../assets/dialogs/dialog_simple.png"
    //height: parent.height*0.5
    //width: parent.width*0.4
    height: app.portrait ? parent.width*0.7 : parent.height*0.6
    width: app.portrait ? parent.width*0.7 : parent.width*0.4

    /*!
      \qmlsignal void DialogGameOver::menuClicked()
      \brief This signal is emitted when the button "Menu" is clicked.
     */
    signal menuClicked()

    /*!
      \qmlsignal void DialogGameOver::restartClicked()
      \brief This signal is emitted when the button "Restart" is clicked.
     */
    signal restartClicked()

    Label {
        anchors.top: parent.top
        anchors.topMargin: app.portrait ? 15 : 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Game over")
        color: "#f3db95"
    }

    Column {
        spacing: 10
        width: parent.width*0.7
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: app.portrait ? 10 : -10
        anchors.verticalCenterOffset: 16

        MenuButton {
            id: buttonResume
            z: 2
            text: qsTr("Menu")
            imageSource: "../../assets/buttons/button_grid_blue.png"
            imageSourcePressed: "../../assets/buttons/button_grid_yellow.png"
            onClicked: {
                imageDialogGameOver.close()
                imageDialogGameOver.menuClicked()
            }
        }
        MenuButton {
            id: buttonRestart
            z: 2
            text: qsTr("Try again")
            imageSource: "../../assets/buttons/button_restart_blue.png"
            imageSourcePressed: "../../assets/buttons/button_restart_yellow.png"
            onClicked: {
                imageDialogGameOver.close()
                imageDialogGameOver.restartClicked()
            }
        }
    }

    /*!
      \qmlmethod void DialogGameOver::open()

      It shows the dialog to the user.
     */
    function open() {
        soundDialog.play()
        imageDialogGameOver.visible = true
    }

    /*!
      \qmlmethod void DialogGameOver::close()

      It closes the dialog.
     */
    function close() {
        imageDialogGameOver.visible = false
    }


    SoundEffectVPlay {
        id: soundDialog
        source: "../../assets/sounds/gameOver.wav"
    }
}
