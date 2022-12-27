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

    CutieLabel {
        id: text1

        width: parent.width - 50
        text: cutieMusic.trackList[playlistView.currentIndex].title
        anchors.top: image.bottom
        anchors.topMargin: 20
        font.pixelSize: 28
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.weight: Font.Black
        elide: Text.ElideRight
    }

    CutieLabel {
        id: text2

        width: parent.width - 50
        text: cutieMusic.trackList[playlistView.currentIndex].artist
        anchors.top: text1.bottom
        anchors.topMargin: 20
        font.pixelSize: 20
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        elide: Text.ElideRight
    }

    Item {
        id: controls

        height: 60
        width: 138
        anchors.bottom: slideritem.top
        anchors.bottomMargin: 25
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            id: image1
            width: 66
            height: 60
            source: (Atmosphere.variant == "dark") ? "/icons/icon-m-previous.svg" : "/icons_black/icon-m-previous.svg"
            anchors.rightMargin: 20
            anchors.right: image2.left
            fillMode: Image.PreserveAspectFit
            sourceSize.height: height
            sourceSize.width: width

            MouseArea {
                id: previous

                anchors.fill: image1
                onClicked: {
                    mediaPlayer.playOnLoad = true;
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
            sourceSize.height: height
            sourceSize.width: width

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
            source: (Atmosphere.variant == "dark") ? "/icons/icon-m-next.svg" : "/icons_black/icon-m-next.svg"
            anchors.leftMargin: 20
            anchors.left: image2.right
            fillMode: Image.PreserveAspectFit
            sourceSize.height: height
            sourceSize.width: width

            MouseArea {
                id: next

                anchors.fill: image3
                onClicked: {
                    mediaPlayer.playOnLoad = true;
                    if (playlistView.currentIndex + 1 < cutieMusic.trackList.length)
                        playlistView.currentIndex++;
                    else playlistView.currentIndex = 0;
                }
            }

        }

    }

    CutieSlider {
        id: slideritem

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 75
        from: 0
        to: mediaPlayer.duration

        value: mediaPlayer.position
        onMoved: {
            mediaPlayer.seek(value);
        }
    }
}
