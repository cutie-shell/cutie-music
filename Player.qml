import Cutie 1.0
import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.15

CutiePage {
    id: player

    property int dpi: 4
    property alias playButton: image2

    width: view.width
    height: view.height

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
        color: (Atmosphere.variant == "dark") ? "white" : "black"
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
        color: (Atmosphere.variant == "dark") ? "white" : "black"
        elide: Text.ElideRight
    }

    Item {
        id: controls

        height: 60
        width: 138
        anchors.bottom: slideritem.top
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            id: image1
            width: 66
            height: 60
            source: (Atmosphere.variant == "dark") ? "/icons/icon-m-previous.svg" : "/icons_black/previous.png"
            anchors.rightMargin: 20
            anchors.right: image2.left
            fillMode: Image.PreserveAspectFit

            MouseArea {
                id: previous

                anchors.fill: image1
                onClicked: {
                    if (playlistView.currentIndex > 0)
                        playlistView.currentIndex--;
                    else playlistView.currentIndex = cutieMusic.trackList.length - 1;
                }
            }

        }

        Image {
            id: image2
            width: 66
            height: 60
            source: miniPlay.source
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit

            MouseArea {
                id: implay

                anchors.fill: image2
                onClicked: {
                    if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                        mediaPlayer.pause();
                    } else {
                        if (mediaPlayer.playbackState === MediaPlayer.StoppedState) {
                            mediaPlayer.source = cutieMusic.trackList[playlistView.currentIndex].path;
                        } 
                        mediaPlayer.play();
                    }
                }
            }

        }

        Image {
            id: image3
            width: 66
            height: 60
            source: (Atmosphere.variant == "dark") ? "/icons/icon-m-next.svg" : "/icons_black/next_black.png"
            anchors.leftMargin: 20
            anchors.left: image2.right
            fillMode: Image.PreserveAspectFit

            MouseArea {
                id: next

                anchors.fill: image3
                onClicked: {
                    if (playlistView.currentIndex + 1 < cutieMusic.trackList.length)
                        playlistView.currentIndex++;
                    else playlistView.currentIndex = 0;
                }
            }

        }

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

            value: mediaPlayer.position
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
                color: (Atmosphere.variant == "dark") ? "#8fffffff" : "#60000000"
            }

            handle: Rectangle {
                x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
                y: root.topPadding + root.availableHeight / 2 - height / 2
                width: 5 * 6
                height: 5 * 6
                radius: width / 2
                color: (Atmosphere.variant == "dark") ? "#ffffff" : "#000000"
            }

        }

    }

}
