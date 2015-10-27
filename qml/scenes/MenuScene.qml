import QtQuick 2.4
import VPlay 2.0
import "../common"

/*!
  \qmltype MenuScene
  \inherits BaseScene
  \brief This scene shows the main menu of the game.
*/

BaseScene {
    id: menuScene

    headerText: qsTr("Collisions")

    // signals that indicating that the an item menu had been selected
    /*!
      \qmlsignal void MenuScene::selectLevelPressed()
      \brief It is emitted when the user selects "Game". {SelectLevelScene} becomes active.
     */
    signal selectLevelPressed

    /*!
      \qmlsignal void MenuScene::settingsPressed()
      \brief It is emitted when the user selects "Settings". {SettingsScene} becomes active.
     */
    signal settingsPressed

    /*!
      \qmlsignal void MenuScene::creditsPressed()
      \brief It is emitted when the user selects "Credits". {CreditScene} becomes active.
     */
    signal creditsPressed

    /*!
      \qmlsignal void MenuScene::quitPressed()
      \brief It is emitted when the user selects "Quit".
     */
    signal quitPressed

    //do not need to see the back button here
    buttonBack.visible: false

    // menu
    Column {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 10
        spacing: 15
        z: 5
        MenuButton {
            text: qsTr("Game")
            imageSource: "../../assets/buttons/button_game_blue.png"
            imageSourcePressed: "../../assets/buttons/button_game_yellow.png"
            onClicked: selectLevelPressed()
        }
        MenuButton {
            text: qsTr("Settings")
            imageSource: "../../assets/buttons/button_settings_blue.png"
            imageSourcePressed: "../../assets/buttons/button_settings_yellow.png"
            onClicked: settingsPressed()
        }
        MenuButton {
            text: qsTr("Credits")
            imageSource: "../../assets/buttons/button_about_blue.png"
            imageSourcePressed: "../../assets/buttons/button_about_yellow.png"
            onClicked: creditsPressed()
        }
        MenuButton {
            text: qsTr("Quit")
            imageSource: "../../assets/buttons/button_quit_blue.png"
            imageSourcePressed: "../../assets/buttons/button_quit_yellow.png"
            onClicked: quitPressed()
        }
    }

    //TODO: maybe there will be some moving balls on the scene
    /*PhysicsWorld {
        id: world
        gravity: Qt.point(0,0)
        running: false
        debugDrawVisible: false
    }*/
}

