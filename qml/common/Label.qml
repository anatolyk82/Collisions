import QtQuick 2.4

Item {
    id: label

    width: txt.paintedWidth
    height: txt.paintedHeight

    property alias font: txt.font
    property alias color: txt.color
    property alias text: txt.text

    FontLoader {
        id: gameFontFont
        source: "../../assets/fonts/ofl.ttf"
    }
    Text {
        id: txt
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text: "Fancy font"
        font.family: gameFontFont.name
    }
}
