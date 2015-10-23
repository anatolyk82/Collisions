import VPlay 2.0
import QtQuick 2.4
import "../common"

BaseScene {
    id: selectLevelScene

    signal levelPressed()

    headerText: qsTr("Levels")


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
            GridView {
                id: levelsGrid
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
                                gameScene.currentLevel = level
                                app.state = "game"
                                gameScene.running = true //start the pysics world
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

    ListModel {
        id: levelModel
        ListElement {
            level: 1
            stars: 3
        }
        ListElement {
            level: 2
            stars: 3
        }
        ListElement {
            level: 3
            stars: 2
        }
        ListElement {
            level: 4
            stars: 3
        }
        ListElement {
            level: 5
            stars: 2
        }
        ListElement {
            level: 6
            stars: 3
        }
        ListElement {
            level: 7
            stars: 2
        }
        ListElement {
            level: 8
            stars: 1
        }
        ListElement {
            level: 9
            stars: 2
        }
        ListElement {
            level: 10
            stars: 1
        }
        ListElement {
            level: 11
            stars: 3
        }
        ListElement {
            level: 12
            stars: 2
        }
        ListElement {
            level: 13
            stars: 2
        }
        ListElement {
            level: 14
            stars: 0
        }
        ListElement {
            level: 15
            stars: 0
        }
        ListElement {
            level: 16
            stars: 0
        }
    }
}

