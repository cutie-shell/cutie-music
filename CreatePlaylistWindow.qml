import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle{
    id: createPlaylistWindow
    width: 400
    height: 800
    color: "transparent"
    border.width: 0
    state: "closed"
    states: [
        State{
            name: "closed"
            PropertyChanges { target: createPlaylistWindow; opacity: 0; enabled: false }
            PropertyChanges {
                target: main.playlistView
               opacity: 1
                enabled: true

            }
            PropertyChanges {
                target: main.frame
                  opacity: 1
                enabled: true

            }
        },

        State {
            name: "opened"
            PropertyChanges { target: createPlaylistWindow; opacity: 1; enabled: true }
            PropertyChanges {
                target: playlistView
                  opacity: 0
                enabled: false

            }

            PropertyChanges {
                target: main.frame
                  opacity: 0
                enabled: false

            }
        }

]
    Label {
        id: label
        x: 64
        y: 12
        width: 140
        height: 27
        text: qsTr("New playlist")
        verticalAlignment: Text.AlignVCenter
        font.bold: false
        font.pointSize: 15
        font.family: "qrc:/fonts/Lato/Lato-Regular.ttf"
    }

    Image {
        id: image
        x: 8
        y: 8
        width: 32
        height: 35
        source: "icons_black/icon-m-dismiss.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: image1
        x: 360
        y: 8
        width: 32
        height: 35
        source: "icons_black/icon-m-accept.png"
        fillMode: Image.PreserveAspectFit
    }

    Rectangle {
        id: rectangle
        height: 1
        color: "#66000000"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 49
        anchors.rightMargin: 8
        anchors.leftMargin: 8
    }

    Image {
        id: image2
        x: 8
        y: 61
        width: 76
        height: 75
        source: "icons/music.png"
        fillMode: Image.PreserveAspectFit
    }

    Label {
        id: label1
        x: 90
        y: 61
        width: 140
        height: 27
        color: "#ab000000"
        text: qsTr("title")
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 13
        font.bold: false
        font.family: "qrc:/fonts/Lato/Lato-Regular.ttf"
    }

    TextField {
        id: textField
        x: 90
        y: 89
        width: 290
        height: 47
        text: "example : for run"
        placeholderText: qsTr("Text Field")
    }

    Label {
        id: label2
        x: 8
        y: 142
        width: 140
        height: 27
        text: qsTr("Our tracks")
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 15
        font.bold: false
        font.family: "qrc:/fonts/Lato/Lato-Regular.ttf"
    }

    ListModel {
        id: addTrack


        ListElement{
            ttext: "trackef dfs  ssdf sd fsf "
        }
    }

    GridView {
        anchors.fill: parent
        anchors.topMargin: 183
        model: addTrack
        cellWidth: 96
        cellHeight: 96
        clip: true

        delegate: Item {
            width: 400
            height: 34
            Rectangle {

               Label {
                    id: text1
                    text: ttext
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    font.pixelSize: 17
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 43
                    anchors.rightMargin: 0
                    font.family: "Lato"
                }

                CheckBox{
                    y: 4
                    width: 29
                    height: 26
                    anchors.left: parent.left
                    anchors.leftMargin: 7

                }
            }
        }


    }



}
