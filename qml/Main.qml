import VPlay 2.0
import QtQuick 2.4
import "scenes"

//com.qtproject.anatolko.Collisions

GameWindow {
    id: window
    width: 960
    height: 640

    // You get free licenseKeys from http://v-play.net/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from http://v-play.net/licenseKey>"
    licenseKey: "88519EB035F6C2BE7C15F05E1229C0CB3EC52B3C72AAA952D96708E01F020EAF57EFECC20194A92FDE5C68EE6240C77ED15BBE4DF7969536C3634267EC2B7EEFF8C2A4B5C4EDFB6CBCFD45A7B8077504DDE277B0980919B162F8DE296D1CA29D2092C244C7157364F66F655E530BCDA8D2E89D412B165A7E33AFD12BB69B69226C1BF2050003C7EBB9F9ED3C901694AA24C9C19971572BC49A04221B8A208C4188B1769A8DBB6D6998ACB75AE6C56BEEFC3E8C535CD1ABBCAAD873372AC4638309603E38A97195D567B72903BA7C29DCDB8B3B1CF0C69640AD325083C71DFE764604F1EEC15E6A3104243F85927833E37E8C3642EF4FC52D0AF24976A2BBCA6B5018C3F815D51ACDDB9C1BAF3410CC43890F459C130BF5AA14B009DE28BACBFAE355771D5E9414DC5D3742249A247EFD"

    // create and remove entities at runtime
    EntityManager {
        id: entityManager
    }

    // menu scene
    MenuScene {
        id: menuScene
        // listen to the button signals of the scene and change the state according to it
        onSelectLevelPressed: window.state = "selectLevel"
        onCreditsPressed: window.state = "credits"
        // the menu scene is our start scene, so if back is pressed there we ask the user if he wants to quit the application
        onBackButtonPressed: {
            nativeUtils.displayMessageBox(qsTr("Really quit the game?"), "", 2);
        }
        // listen to the return value of the MessageBox
        Connections {
            target: nativeUtils
            onMessageBoxFinished: {
                // only quit, if the activeScene is menuScene - the messageBox might also get opened from other scenes in your code
                if(accepted && window.activeScene === menuScene)
                    Qt.quit()
            }
        }
    }

    // scene for selecting levels
    SelectLevelScene {
        id: selectLevelScene
        onLevelPressed: {
            // selectedLevel is the parameter of the levelPressed signal
            gameScene.setLevel(selectedLevel)
            window.state = "game"

        }
        onBackButtonPressed: window.state = "menu"
    }

    // credits scene
    CreditsScene {
        id: creditsScene
        onBackButtonPressed: window.state = "menu"
    }

    // game scene to play a level
    GameScene {
        id: gameScene
        onBackButtonPressed: window.state = "selectLevel"
    }

    // menuScene is our first scene, so set the state to menu initially
    state: "menu"
    activeScene: menuScene

    // state machine, takes care reversing the PropertyChanges when changing the state, like changing the opacity back to 0
    states: [
        State {
            name: "menu"
            PropertyChanges {target: menuScene; opacity: 1}
            PropertyChanges {target: window; activeScene: menuScene}
        },
        State {
            name: "selectLevel"
            PropertyChanges {target: selectLevelScene; opacity: 1}
            PropertyChanges {target: window; activeScene: selectLevelScene}
        },
        State {
            name: "credits"
            PropertyChanges {target: creditsScene; opacity: 1}
            PropertyChanges {target: window; activeScene: creditsScene}
        },
        State {
            name: "game"
            PropertyChanges {target: gameScene; opacity: 1}
            PropertyChanges {target: window; activeScene: gameScene}
        }
    ]
}

