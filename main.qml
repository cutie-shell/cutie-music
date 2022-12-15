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

    property var player: Qt.createComponent("Player.qml")

    width: 400
    height: 800
    visible: true
    title: qsTr("Music")

    initialPage: CutiePage {
        width: view.width
        height: view.height
        Rectangle {
            id: miniControls

            y: 424
            height: 70
            color: (Atmosphere.variant == "dark") ? "#2effffff" : "#5c000000"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            Image {
                id: miniCover
                y: 10
                width: 50
                height: 50
                anchors.leftMargin: 10
                anchors.left: parent.left
                fillMode: Image.PreserveAspectFit
                source: cutieMusic.trackList[playlistView.currentIndex].path.toString().replace("file:///", "image://cover/")
            }

            Text {
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.leftMargin: 10
                anchors.left: miniCover.right
                anchors.rightMargin: 10
                anchors.right: miniPlay.left
                text: cutieMusic.trackList[playlistView.currentIndex].title
                font.pixelSize: 20
                color: (Atmosphere.variant == "dark") ? "white" : "black"
                elide: Text.ElideRight
            }


            Text {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.leftMargin: 10
                anchors.left: miniCover.right
                anchors.rightMargin: 10
                anchors.right: miniPlay.left
                text: cutieMusic.trackList[playlistView.currentIndex].artist
                font.pixelSize: 13
                color: (Atmosphere.variant == "dark") ? "white" : "black"
                elide: Text.ElideRight
            }

            Item {
                x: 0
                y: 0
                height: parent.height
                width: parent.width
                z: 100

                MouseArea {
                    anchors.fill: parent
                    onReleased: {
                        view.pageStack.push(player, {});
                    }
                }

            }

            Image {
                id: miniPlay
                y: 10
                width: 55
                height: 50
                anchors.rightMargin: 10
                anchors.right: parent.right
                fillMode: Image.PreserveAspectFit
		source: (Atmosphere.variant == "dark") ? "/icons/icon-m-play.svg" : "/icons_black/icon-m-play.svg"
                z: 200

                MouseArea {
                    id: miniimplay

                    anchors.fill: miniPlay
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
                    miniPlay.source = Qt.binding(() => (Atmosphere.variant == "dark") ? "/icons/icon-m-pause.svg" : "/icons_black/icon-m-pause.svg");
                } else {
                    miniPlay.source = Qt.binding(() => (Atmosphere.variant == "dark") ? "/icons/icon-m-play.svg" : "/icons_black/icon-m-play.svg");
                }
            }
        }

        ListView {
            id: playlistView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: miniControls.top
            anchors.top: parent.top
            model: cutieMusic.trackList
            delegate: playlistDelegate
            highlight: playlistHighlight
            clip: true
            header: CutiePageHeader {
                id: titleM
                title: qsTr("Music")
            }

            onCurrentIndexChanged: {
                mediaPlayer.source = cutieMusic.trackList[currentIndex].path;
                mediaPlayer.play();
            }
        }

        Component {
            id: playlistHighlight

            Item {
                y: playlistView.currentItem.y
                Rectangle {
                    color: (Atmosphere.variant == "dark") ? "#5cffffff" : "#5c000000"
                    radius: 5
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20

                    Behavior on y {
                        SpringAnimation {
                            spring: 3
                            damping: 0.2
                        }

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
                    color: (Atmosphere.variant == "dark") ? "#5cffffff" : "#5c000000"
                    radius: 5
                    visible: mouse.pressed
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                }

                Image {
                    id: image
                    x: 30
                    width: 40
                    height: 40
                    source: modelData.path.toString().replace("file:///", "image://cover/")
                    anchors.verticalCenter: parent.verticalCenter
                    sourceSize.height: height
                    sourceSize.width: width
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    x: 80
                    y: 10
                    text: modelData.title
                    font.pixelSize: 12
                    color: (Atmosphere.variant == "dark") ? "white" : "black"
                }


                Text {
                    x: 80
                    y: 30
                    text: modelData.artist
                    font.pixelSize: 9
                    color: (Atmosphere.variant == "dark") ? "white" : "black"
                }

                MouseArea {
                    id: mouse

                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    onClicked: {
                        playlistView.currentIndex = index;
                    }
                }

            }

        }
    }

}
