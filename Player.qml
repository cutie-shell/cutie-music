import Cutie 1.0
import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: player

    property int dpi: 4

    width: view.width
    height: view.height
    color: "#00ffffff"
    // id: playerSlate
    state: "closed"
    states: [
        State {
            name: "closed"

            PropertyChanges {
                target: player
                opacity: 0
                y: view.height
            }

            PropertyChanges {
                target: playlistView
                opacity: 1
                enabled: true
            }

        },
        State {
            name: "unopened"

            PropertyChanges {
                target: player
                opacity: 0
                y: view.height
            }

        },
        State {
            name: "opened"

            PropertyChanges {
                target: player
                opacity: 1
                y: 0
            }

            PropertyChanges {
                target: playlistView
                opacity: 0
                enabled: false
            }

        }
    ]
    transitions: [
        Transition {
            to: "opened"

            NumberAnimation {
                target: player
                properties: "opacity"
                duration: 300
                easing.type: Easing.InOutQuad
            }

        },
        Transition {
            to: "closed"

            NumberAnimation {
                target: player
                properties: "opacity"
                duration: 300
                easing.type: Easing.InOutQuad
            }

        }
    ]

    Image {
        id: image

        x: 83
        width: 234
        height: 236
        anchors.top: parent.top
        source: cutieMusic.trackList[playlistView.currentIndex].path.toString().replace("file:///", "image://cover/")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 58
        sourceSize.height: 800
        sourceSize.width: 800
        fillMode: Image.PreserveAspectFit
    }

    Label {
        id: text1

        width: parent.width - 50
        text: cutieMusic.trackList[playlistView.currentIndex].title
        anchors.top: image.bottom
        anchors.topMargin: 20
        font.pixelSize: 32
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Lato"
        font.weight: Font.Black
        color: (atmospheresHandler.variant == "dark") ? "white" : "black"
        elide: Text.ElideRight
    }

    Label {
        id: text2

        x: 143
        width: parent.width - 50
        text: cutieMusic.trackList[playlistView.currentIndex].artist
        anchors.top: text1.bottom
        anchors.topMargin: 20
        font.pixelSize: 24
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Lato"
        font.weight: Font.Normal
        color: (atmospheresHandler.variant == "dark") ? "white" : "black"
        elide: Text.ElideRight
    }

    Rectangle {
        id: slideritem

        y: 824
        height: 53
        color: "#00ffffff"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100

        Slider {
            id: root

            // z: 3
            property string valueText: ""
            property string label: ""
            property real minimumValue: 0
            property real maximumValue: mediaPlayer.duration
            property bool sync: false

            value: mediaPlayer.duration
            anchors.fill: parent
            onValueChanged: {
                if (!sync)
                    mediaPlayer.seek(value);

            }
            from: minimumValue
            to: maximumValue
            leftPadding: 2 * 5
            rightPadding: 2 * 5
            topPadding: 1 * 5
            bottomPadding: 1 * 5

            Connections {
                target: mediaPlayer
                onPositionChanged: {
                    root.sync = true;
                    root.value = mediaPlayer.position;
                    root.sync = false;
                }
            }

            background: Rectangle {
                x: root.leftPadding + 3 * 5
                y: root.topPadding + 3.5 * 5
                height: 5 / 2
                width: root.availableWidth - root.rightPadding - root.leftPadding
                radius: 5 / 4
                color: (atmospheresHandler.variant == "dark") ? "#8fffffff" : "#60000000"
            }

            handle: Rectangle {
                x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
                y: root.topPadding + root.availableHeight / 2 - height / 2
                width: 5 * 6
                height: 5 * 6
                radius: width / 2
                color: (atmospheresHandler.variant == "dark") ? "#ffffff" : "#000000"
            }

        }

    }

}
