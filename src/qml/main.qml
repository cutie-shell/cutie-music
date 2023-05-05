import Cutie
import Qt.labs.folderlistmodel
import Qt5Compat.GraphicalEffects
import QtMultimedia
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Window

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

            audioOutput: AudioOutput {}

            property bool playOnLoad: false

            onMediaStatusChanged: {
                if (mediaStatus == MediaPlayer.EndOfMedia) {
                    playOnLoad = true;
                    if (playlistView.currentIndex + 1 < cutieMusic.trackList.length)
                        playlistView.currentIndex++;
                    else playlistView.currentIndex = 0;
                } else if (mediaStatus == MediaPlayer.LoadedMedia && playOnLoad) {
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
            
            onErrorOccurred: {
                console.error(errorString);
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
                }
            }
        }
    }
}
