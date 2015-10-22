import QtQuick 2.4

Item {
    id: label

    width: txt.paintedWidth
    height: txt.paintedHeight

    property alias font: txt.font
    property alias color: txt.color
    property alias text: txt.text

    //in case if the label contains a link
    signal linkClicked(string link)

    FontLoader {
        id: gameFontFont
        source: "../../assets/fonts/ofl.ttf"
    }
    Text {
        id: txt
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        font.family: gameFontFont.name
        onLinkActivated: { label.linkClicked(link) }
    }
}
