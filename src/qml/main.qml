import Cutie 1.0
import Qt.labs.folderlistmodel 2.12
import QtGraphicalEffects 1.0
import QtMultimedia 5.15
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.12

// Authors: Alexey T. (vin4ter), Erik Inkinen
CutieWindow {
    id: view
    property bool playedStatus: false
    property int value: 0
    property bool btnPlayslate: false
    property int toMove: 0
    property int colPlaylist: 0

    width: 400
    height: 800
    visible: true
    title: qsTr("Music")

    initialPage: CutiePage {
        width: view.width
        height: view.height
        Rectangle {
            id: miniControls

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

            CutieLabel {
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.leftMargin: 10
                anchors.left: miniCover.right
                anchors.rightMargin: 10
                anchors.right: miniPlay.left
                text: cutieMusic.trackList[playlistView.currentIndex].title
                font.pixelSize: 20
                elide: Text.ElideRight
            }


            CutieLabel {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.leftMargin: 10
                anchors.left: miniCover.right
                anchors.rightMargin: 10
                anchors.right: miniPlay.left
                text: cutieMusic.trackList[playlistView.currentIndex].artist
                font.pixelSize: 13
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
                        view.pageStack.push("qrc:/Player.qml", {});
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
                sourceSize.height: height
                sourceSize.width: width
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

            property bool playOnLoad: false

            onStatusChanged: {
                if (status == MediaPlayer.EndOfMedia) {
                    if (playlistView.currentIndex + 1 < cutieMusic.trackList.length)
                        playlistView.currentIndex++;
                    else playlistView.currentIndex = 0;
                    playOnLoad = true;
                } else if (status == MediaPlayer.Loaded && playOnLoad) {
                    playOnLoad = false;
                    play();
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

        CutieListView {
            id: playlistView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: miniControls.top
            anchors.top: parent.top
            model: cutieMusic.trackList
            delegate: playlistDelegate
            clip: true
            header: CutiePageHeader {
                id: titleM
                title: qsTr("Music")
            }

            onCurrentIndexChanged: {
                mediaPlayer.source = cutieMusic.trackList[currentIndex].path;
            }
        }

        Component {
            id: playlistDelegate

            CutieListItem {
                highlighted: playlistView.currentIndex == index
                icon.source: modelData.path.toString().replace("file:///", "image://cover/")
                icon.width: 40
                icon.height: 40
                iconOverlay: false
                text: modelData.title
                subText: modelData.artist
                onClicked: {
                    mediaPlayer.playOnLoad = true;
                    playlistView.currentIndex = index;
                    mediaPlayer.play();
                }
            }
        }
    }
}
