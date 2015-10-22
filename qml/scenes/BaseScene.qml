import VPlay 2.0
import QtQuick 2.0
import "../common"

/*
 * This is the main scene for all scenes in the game
 */


SceneBase {
    id: baseScene

    /* properties for configuration of the scene page */
    property alias backText: buttonBack.text
    property alias buttonBack: buttonBack

    property alias imageBackground: imageBackground.source

    property alias headerText: labelLogo.text
    property alias header: labelLogo


    //the back button
    MenuButton {
        id: buttonBack
        z: 2
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        text: qsTr("Back")
        imageSource: "../../assets/buttons/button_menu_blue.png"
        imageSourcePressed: "../../assets/buttons/button_menu_yellow.png"
        onClicked: backButtonPressed()
    }


    //background image
    MultiResolutionImage {
        id: imageBackground
        smooth: true
        antialiasing: true
        anchors.fill: parent.gameWindowAnchorItem
        source: "../../assets/backgrounds/background.jpg"
    }

    // the header
    Label {
        id: labelLogo
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 18
        font.pixelSize: 32
        color: "blue"
        font.bold: true
    }
}
