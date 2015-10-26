import QtQuick 2.4
import VPlay 2.0


MultiResolutionImage {
    id: imageDialogGameOver
    z: 20
    visible: false
    smooth: true
    antialiasing: true
    anchors.centerIn: parent
    source: "../../assets/dialogs/dialog_simple.png"
    height: parent.height*0.5
    width: parent.width*0.4

    signal menuClicked()
    signal restartClicked()

    Label {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Game over")
        color: "#f3db95"
    }

    Column {
        spacing: 5
        width: parent.width*0.7
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -10
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

    function open() {
        soundDialog.play()
        imageDialogGameOver.visible = true
    }

    function close() {
        imageDialogGameOver.visible = false
    }


    SoundEffectVPlay {
        id: soundDialog
        source: "../../assets/sounds/gameOver.wav"
    }
}
