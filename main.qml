import Cutie 1.0
import Qt.labs.folderlistmodel 2.12
import QtGraphicalEffects 1.0
import QtMultimedia 5.15
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.12

//Alexey T. (vin4ter) GNU GPL3
CutieWindow {
    id: view

    property bool debug: false
    //Debug true or false for release in cutieShell DE please use false
    property bool playedStatus: false
    property int value: 0
    property bool btnPlayslate: false
    property int toMove: 0
    property int colPlaylist: 0

    width: 400
    height: 800
    visible: true
    title: qsTr("Music")

    Rectangle {
        id: miniControls

        y: 424
        height: 56
        color: (atmospheresHandler.variant == "dark") ? "#2effffff" : "#5c000000"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Item {
            x: 0
            y: 0
            //  z: 100
            height: parent.height
            width: parent.width

            MouseArea {
                anchors.fill: parent
                onReleased: {
                    if (player.state == "closed")
                        player.state = "opened";
                    else
                        player.state = "closed";
                }
            }

        }

        Image {
            id: image1

            x: 248
            y: 8
            width: 44
            height: 40
            source: (atmospheresHandler.variant == "dark") ? "/icons/icon-m-previous.svg" : "/icons_black/previous.png"
            anchors.horizontalCenterOffset: -50
            anchors.horizontalCenter: image2.horizontalCenter
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

            x: 298
            y: 8
            width: 44
            height: 40
            source: (atmospheresHandler.variant == "dark") ? "/icons/icon-m-play.svg" : "/icons_black/play.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 0
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

            x: 348
            y: 8
            width: 44
            height: 40
            source: (atmospheresHandler.variant == "dark") ? "/icons/icon-m-next.svg" : "/icons_black/next_black.png"
            anchors.horizontalCenter: image2.horizontalCenter
            anchors.horizontalCenterOffset: 50
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

    MediaPlayer {
        id: mediaPlayer

        readonly property string title: !!metaData.author && !!metaData.title ? qsTr("%1 - %2").arg(metaData.author).arg(metaData.title) : metaData.author || metaData.title || source

        audioRole: MediaPlayer.MusicRole

        onStatusChanged: {
            if (status == MediaPlayer.EndOfMedia) {
                if (playlistView.currentIndex + 1 < cutieMusic.trackList.length)
                    playlistView.currentIndex++;
                else playlistView.currentIndex = 0;
            }
        }

        onPlaybackStateChanged: {
            if (playbackState == MediaPlayer.PlayingState) {
                image2.source = (atmospheresHandler.variant == "dark") ? "/icons/icon-m-pause.svg" : "/icons_black/pause_black.png";
            } else {
                image2.source = (atmospheresHandler.variant == "dark") ? "/icons/icon-m-play.svg" : "/icons_black/play.png";
            }
        }
    }

    ListView {
        id: playlistView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: miniControls.top
        anchors.top: parent.top
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        model: cutieMusic.trackList
        delegate: playlistDelegate
        highlight: playlistHighlight
        clip: true
        header: Label {
            id: titleM
            text: qsTr("Music")
            font.pointSize: 32
            font.family: "Lato"
            font.weight: Font.Bold
            height: implicitHeight + 40
            color: (atmospheresHandler.variant == "dark") ? "white" : "black"
            verticalAlignment: Text.AlignVCenter
        }

        onCurrentIndexChanged: {
            mediaPlayer.source = cutieMusic.trackList[currentIndex].path;
            mediaPlayer.play();
        }
    }

    Component {
        id: playlistHighlight

        Rectangle {
            color: (atmospheresHandler.variant == "dark") ? "#5cffffff" : "#5c000000"
            radius: 5
            y: playlistView.currentItem.y

            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }

            }

        }

    }

    Component {
        id: playlistDelegate

        Item {
            width: playlistView.width
            height: 50

            Rectangle {
                id: rectItem

                anchors.fill: parent
                color: (atmospheresHandler.variant == "dark") ? "#5cffffff" : "#5c000000"
                radius: 5
                visible: mouse.pressed
            }

            Image {
                id: image
                x: 10
                width: 40
                height: 40
                source: modelData.path.toString().replace("file:///", "image://cover/")
                anchors.verticalCenter: parent.verticalCenter
                sourceSize.height: height
                sourceSize.width: width
                fillMode: Image.PreserveAspectFit
            }

            Text {
                x: 60
                y: 10
                text: modelData.title
		        font.pixelSize: 12
                color: (atmospheresHandler.variant == "dark") ? "white" : "black"
            }


            Text {
                x: 60
                y: 30
                text: modelData.artist
		        font.pixelSize: 9
                color: (atmospheresHandler.variant == "dark") ? "white" : "black"
            }


            MouseArea {
                id: mouse

                anchors.fill: parent
                onClicked: {
                    playlistView.currentIndex = index;
                }
            }

        }

    }

    Player {
        id: player
    }

    CreatePlaylistWindow {
        id: createPlaylistWindow
    }

}
