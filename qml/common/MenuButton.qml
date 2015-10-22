import QtQuick 2.4
import VPlay 2.0

Rectangle {
    id: button

    width: imageButton.width + buttonText.width
    height: 30

    color: "transparent"

    // access the text of the Text component
    property alias text: buttonText.text

    // this handler is called when the button is clicked.
    signal clicked

    //images of button for different states
    property url imageSource: ""
    property url imageSourcePressed: ""
    property url imageSourceChecked: ""

    //whether the button is checkable
    property bool checkable: false
    property bool checked: false

    //colors of text
    property color textColor: "black"
    property color textColorPressed: "yellow"
    property color textColorChecked: "grey"

    //size of text
    property alias textSize: buttonText.font.pixelSize


    MultiResolutionImage {
        id: imageButton
        smooth: true
        antialiasing: true
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        height: parent.height*0.9
        fillMode: Image.PreserveAspectFit
        source: mouseArea.pressed ? imageSourcePressed : (button.checkable ? (button.checked ? imageSource : imageSourceChecked) : imageSource)
    }

    Label {
        id: buttonText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: imageButton.right
        anchors.leftMargin: 10
        font.pixelSize: 18
        color: mouseArea.pressed ? textColorPressed : (button.checkable ? (button.checked ? textColor : textColorChecked) : textColor)
    }

    //cover the button with a mouse area
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        //hoverEnabled: true
        onClicked: {
            if( button.checkable ) {
                button.checked = !button.checked
            }
            button.clicked()
        }
        //onEntered: {}
        //onExited: {}
    }
}

