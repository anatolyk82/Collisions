import QtQuick 2.4


Text {
    id: txt
    font.family: gameFontFont.name
    onLinkActivated: { Qt.openUrlExternally(link) }

    FontLoader {
        id: gameFontFont
        source: "../../assets/fonts/ofl.ttf"
    }
}
