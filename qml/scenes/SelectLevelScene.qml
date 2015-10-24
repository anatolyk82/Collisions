import VPlay 2.0
import QtQuick 2.0

import "../common"

BaseScene {
    id: selectLevelScene

    signal levelPressed()

    headerText: qsTr("Levels")

    property bool howToPlayVisible: false

    MenuButton {
        id: buttonHowToPlay
        z: 2
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        text: howToPlayVisible ? qsTr("Back to levels") : qsTr("How to play")
        imageSource: "../../assets/buttons/button_about_blue.png"
        imageSourcePressed: "../../assets/buttons/button_about_yellow.png"
        onClicked: {
            howToPlayVisible = !howToPlayVisible
        }
    }


    MultiResolutionImage {
        id: imageBackgroundDialog
        smooth: true
        antialiasing: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: header.bottom
        source: "../../assets/dialogs/dialog_level_select.png"
        height: parent.height*0.8
        width: parent.width*0.75

        Rectangle {
            id: gridWrapper
            anchors.fill: parent
            anchors.topMargin: 60
            anchors.leftMargin: 21
            anchors.rightMargin: 28
            anchors.bottomMargin: 45
            //border.color: "black"
            color: "transparent"
            clip: true
            Flickable {
                visible: howToPlayVisible == true
                anchors.fill: parent
                clip: true
                contentWidth: itemContent.width
                contentHeight: itemContent.height
                flickableDirection: Flickable.VerticalFlick
                Label {
                    id: itemContent
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: gridWrapper.width
                    wrapMode: Text.WordWrap
                    text: qsTr(" Not everyone likes when someone is different, not like others. The same has happened to one big ball. It's bigger, it's heavier and it has some decorations on the surface. Other balls do not like it and they always try to destroy the ball just because it differs. Your purpose is to move the big ball over the game field to avoid collisions with other balls. Be careful, the big ball is heavy and you can lose control over the ball by moving it too fast. Each level will be harder for you but you should try. Save the big ball !")
                }
            }

            GridView {
                id: levelsGrid
                visible: howToPlayVisible == false
                anchors.fill: parent
                model: levelModel
                cellWidth: gridWrapper.width*0.25
                cellHeight: cellWidth
                delegate: Rectangle {
                    id: delegateWrapper
                    color: "transparent"
                    width: levelsGrid.cellWidth
                    height: levelsGrid.cellHeight
                    //border.color: "blue"

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: {
                            if( !isLevelLock( index, stars ) ) {
                                gameScene.initGame( index )
                                app.state = "game"
                                gameScene.start() //start the pysics world
                            }
                        }
                    }

                    Image {
                        id: imageStars
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        width: parent.width*0.7
                        fillMode: Image.PreserveAspectFit
                        source: {
                            if(stars == 0 )
                                "../../assets/img/stars_border_0.png"
                            else if (stars == 1)
                                "../../assets/img/stars_border_1.png"
                            else if (stars == 2)
                                "../../assets/img/stars_border_2.png"
                            else
                                "../../assets/img/stars_border_3.png"
                        }
                    }

                    Image {
                        id: imageLevel
                        smooth: true
                        antialiasing: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: imageStars.bottom
                        source: isLevelLock( index, stars ) ?
                                    "../../assets/buttons/button_empty_grey.png" :
                                    "../../assets/buttons/button_empty_blue.png"
                        height: parent.height*0.6
                        width: parent.width*0.6
                        Label {
                            anchors.centerIn: parent
                            text: level
                            font.bold: true
                            font.pixelSize: parent.height*0.5
                            //color: stars == 0 ? "grey" : mouseArea.pressed ? "yellow" : "blue"
                            color: isLevelLock( index, stars ) ? "grey" : mouseArea.pressed ? "yellow" : "blue"
                        }
                    }
                }
            }
        }
    }

    function isLevelLock( index, stars ) {
        if( index == 0 ) {
            return false
        } else if(stars != 0 ) {
            return false
        } else {
            var prev_stars = levelModel.get((index-1)).stars
            if( prev_stars != 0 ) {
                return false
            } else {
                return true
            }
        }
    }

}

