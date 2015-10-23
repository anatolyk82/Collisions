import QtQuick 2.4
import VPlay 2.0



MultiResolutionImage {
    id: imageDialogPause
    visible: false
    smooth: true
    antialiasing: true
    anchors.centerIn: parent
    source: "../../assets/dialogs/dialog_simple.png"
    height: parent.height*0.7
    width: parent.width*0.4

    Column {
        spacing: 5
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -10
        anchors.verticalCenterOffset: 16
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 30
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
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Resume")
            imageSource: "../../assets/buttons/button_ok_blue.png"
            imageSourcePressed: "../../assets/buttons/button_ok_yellow.png"
            onClicked: {
                imageDialogPause.close()
                //continue the game
            }
        }
        MenuButton {
            id: buttonRestart
            z: 2
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Restart")
            imageSource: "../../assets/buttons/button_restart_blue.png"
            imageSourcePressed: "../../assets/buttons/button_restart_yellow.png"
            onClicked: {
                imageDialogPause.close()
                //retsart the game
            }
        }
    }

    function open() {
        imageDialogPause.visible = true
    }

    function close() {
        imageDialogPause.visible = false
    }
}


