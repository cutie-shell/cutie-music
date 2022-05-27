import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtMultimedia 5.15
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import Qt.labs.folderlistmodel 2.12
import Cutie 1.0
//Alexey T. (vin4ter) GNU GPL3
CutieWindow{
    id: view
    width: 400
    height: 800
    visible: true
    title: qsTr("Music")
    //cutieMusic.onSendString:
    property  bool debug: false //Debug true or false for release in cutieShell DE please use false
    property bool playedStatus: false

    property  int value: 0
    property  bool btnPlayslate: false
    property int toMove: 0
    property int colPlaylist: 0
    //0 - Null unactvie
    //1 - true auto
    //2 - forward false
    //3 - forward true
    //4 - back false
    //5 - back true
    //color: "transparent"
//createPlaylistWindow.slate: "opened"


    ///    searchMusic()

   /* Image {
        id: bug
        width: 0
        height: 0
        source: "file:/usr/share/atmospheres/air/wallpaper.jpg"
        sourceSize.height: 1080
        sourceSize.width: 1920
        fillMode: Image.PreserveAspectCrop

        smooth: true
        visible: false
        anchors.fill: parent
    }


    FastBlur {
        source: bug
        radius: 32
        anchors.fill: parent
    }

*/

    Connections {
        target: cutieMusic

        onSendString: {
            playlistModel.append( { "path" : current_line, } )
        }
    }




/*

    ListModel {
                  id: playlistsModel



    }


    ScrollView {
          id: frame
          clip: true

          //other properties
         // ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.bottom: scroll.top
          anchors.rightMargin: 0
          anchors.leftMargin: 0
          anchors.topMargin: 0
                    anchors.bottomMargin: 6
          Flickable {
              contentWidth: colPlaylist *96
              height: 96







    GridView {
         anchors.fill: parent
                  model: playlistsModel
                  cellWidth: 96
                  cellHeight: 96
                  clip: true

                  delegate: Item {
                      width: view.width / 3 - 15 * shellScaleFactor
                      height: view.width / 3 - 15 * shellScaleFactor
                      Rectangle {
                          id: modelplaylist
                          x: 8
                          y: 8
                          width: 89
                          height: 89
                          color: "#87ffffff"

                          Label {
                              id: text1
                              x: 0
                              y: 92
                              width: 89
                              height: 33
                              text: atext
                              font.pixelSize: 12
                              wrapMode: Text.WrapAnywhere
                          }

                          Image {
                              id: image
                              anchors.fill: parent
                              source: bicon
                              sourceSize.height: 89
                              sourceSize.width: 89
                              fillMode: Image.PreserveAspectFit
                          }
                      }
                  }
              }
          }
    }








*/












    Rectangle {
        id: miniControls
        y: 424
        height: 56
        color: (atmospheresHandler.variant == "dark") ? "#2effffff" : "#5c000000"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        Item {
            x: 0
            y: 0
            //  z: 100
            height: parent.height
            width: parent.width

            MouseArea {
                //   enabled: (settingsState.state != "opened") && (screenLockState.state == "opened")
                //  drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: 0; drag.maximumY: view.height
                anchors.fill: parent

                onReleased: {
                    //if (parent.y < parent.height) {
                    if(player.state=="closed"){
                        player.state = "opened"
                        // player.setSettingContainerState("opened");

                    }else{
                        player.state = "closed"
                        // player.setSettingContainerState("closed");
                    }

                    //  parent.y = 0
                }

                // onPositionChanged: {
                //      if (drag.active) {
                //          player.opacity = parent.y / view.height / 2;
                //          player.setSettingContainerY(parent.y - view.height);
                //    }
                //  }


            }
        }
        Image {
            id: image1
            x: 248
            y: 8
            width: 44
            height: 40
            source: (atmospheresHandler.variant == "dark") ?   "/icons/icon-m-previous.svg":"/icons_black/previus.png"
            anchors.horizontalCenterOffset: -50
            anchors.horizontalCenter: image2.horizontalCenter
            fillMode: Image.PreserveAspectFit
            MouseArea{
                anchors.fill: image1
                id: previus
                onClicked: {
                    toMove = 4
                    mediaPlayer.stop()

                }
            }
        }

        Image {
            id: image2
            x: 298
            y: 8
            width: 44
            height: 40
            source: (atmospheresHandler.variant == "dark") ? "/icons/icon-m-play.svg":"/icons_black/play.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 0
            fillMode: Image.PreserveAspectFit
            MouseArea{
                anchors.fill: image2
                id: implay
                onClicked: {

                    if (mediaPlayer.playbackState === MediaPlayer.PlayingState){
                        mediaPlayer.pause()
                        image2.source = (atmospheresHandler.variant == "dark") ? "/icons/icon-m-play.svg":"/icons_black/play.png"
                        btnPlayslate = false
                    }else if (mediaPlayer.playbackState === MediaPlayer.StoppedState) {
                        var index = playlistView.currentIndex
                        image2.source = (atmospheresHandler.variant == "dark") ?   "/icons/icon-m-pause.svg":"/icons_black/pause_black.png"
                        btnPlayslate: true
                        var path = playlistModel.get(index)["path"]
                        mediaPlayer.source = path

                        mediaPlayer.play()
                    } else{
                        mediaPlayer.play()
                        btnPlayslate: true

                        image2.source = (atmospheresHandler.variant == "dark") ?   "/icons/icon-m-pause.svg":"/icons_black/pause_black.png"
                        // playedStatus=true

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
            source: (atmospheresHandler.variant == "dark") ?   "/icons/icon-m-next.svg":"/icons_black/next_black.png"
            anchors.horizontalCenter: image2.horizontalCenter
            anchors.horizontalCenterOffset: 50
            fillMode: Image.PreserveAspectFit
            MouseArea{
                anchors.fill: image3
                id: next

                onClicked: {
                    //onClicked: addingMusicDialog.open()
                    //   playlistView.currentIndex++
                    //  var index = playlistView.currentIndex
                    //  var path = playlistModel.get(index)["path"]
                    //mediaPlayer.source = path
                    //  mediaPlayer.play()
                    toMove = 2
                    mediaPlayer.stop()

                }
            }
        }
    }

    MediaPlayer {
        id: mediaPlayer
        //   autoPlay: true
        source : url
        audioRole: MediaPlayer.MusicRole
        readonly property string title: !!metaData.author && !!metaData.title
                                        ? qsTr("%1 - %2").arg(metaData.author).arg(metaData.title)
                                        : metaData.author || metaData.title || source
        onStopped: {
            if(toMove ==  0){
                playlistView.currentIndex++
                var index = playlistView.currentIndex
                var path = playlistModel.get(index)["path"]
                mediaPlayer.source = path

                toMove= 1
                slatetime.start()

            }else if(toMove==2){
                playlistView.currentIndex++
                var index = playlistView.currentIndex
                var path = playlistModel.get(index)["path"]
                mediaPlayer.source = path

                toMove= 3
                slatetime.start()

            }else if(toMove==4){
                playlistView.currentIndex--
                var index = playlistView.currentIndex
                var path = playlistModel.get(index)["path"]
                mediaPlayer.source = path

                toMove= 5
                slatetime.start()

            }

        }

        onPlaylistChanged:{

        }

        onPlaying:{

        }
    }
    Timer {
        id: slatetime
        interval: 2000; running: true; repeat: false
        onTriggered: {
            toMove=0
            mediaPlayer.play()
        }
    }

    ScrollView {
        id: scroll
        x: 0
        y: 0
        height: 653
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 55
        anchors.topMargin: 45
        //Layout.fillWidth: true
        //Layout.fillHeight: true
        // flickableItem.interactive: true

        ListView {
            id: playlistView
            y: 0
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            model: playlistModel
            delegate: playlistDelegate
            //                    delegate: PlaylistDelegate {  }
            highlight: playlistHighlight
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
    ListModel {
        id: playlistModel
    }
    Component {
        id: playlistDelegate

        Item {
            width: parent.width
            height: 30

            Rectangle {
                id : rectItem
                anchors.fill: parent
                color: (atmospheresHandler.variant == "dark") ? "#5cffffff" : "#5c000000"
                radius: 5
                visible: mouse.pressed
            }

            Text {
                x: 10
                y: 10
                text: path
                color:  (atmospheresHandler.variant == "dark") ? "white" : "black"
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                onClicked: playlistView.currentIndex = index
                onDoubleClicked:{
                    btnPlayslate=true
                    image2.source = (atmospheresHandler.variant == "dark") ? "/icons/icon-m-play.svg":"/icons_black/play.png"
                    mediaPlayer.source = path

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

    Label {
        id: titleM
        width: 116
        height: 29
        text: qsTr("Your music")
        anchors.left: parent.left
        anchors.top: parent.top
        font.pointSize: 14
        anchors.leftMargin: 8
        font.family: "Lato"
        anchors.topMargin: 8
        color:  (atmospheresHandler.variant == "dark") ? "white" : "black"
    }

    Rectangle {
        id: rectangleM
        height: 1
        color:     (atmospheresHandler.variant == "dark") ? "white" : "#66000000"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 36
    }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/
