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
    title: qsTr("Scroll")
    //cutieMusic.onSendString:
    property  bool debug: false //Debug true or false for release in cutieShell DE
    property bool playedStatus: false

    property  int value: 0
    property  bool btnPlayslate: false
    //color: "transparent"



    ///    searchMusic()

    Connections {
          target: cutieMusic

         onSendString: {
          playlistModel.append( { "path" : current_line, } )
          }
      }




    FolderListModel{
        id: listmusic
        folder: "file:///home/alex/Музыка"
                   showDirs: false
                  // showDotAndDotDot: false
                   nameFilters: ["*.mp3"]

    }



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
                    onClicked: {
                        playlistView.currentIndex--
                        var index = playlistView.currentIndex
                        var path = playlistModel.get(index)["path"]
                        mediaPlayer.source = path
       playedStatus=true
                           mediaPlayer.play()

                }
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
   playedStatus=false
                        }else if (mediaPlayer.playbackState === MediaPlayer.StoppedState) {
                            var index = playlistView.currentIndex
                                image2.source = (atmospheresHandler.variant == "dark") ?   "/icons/icon-m-pause.svg":"/icons_black/pause_black.png"
                            btnPlayslate: true
                            var path = playlistModel.get(index)["path"]
                            mediaPlayer.source = path
   playedStatus=true
                               mediaPlayer.play()
                        } else{
                            mediaPlayer.play()
                            btnPlayslate: true

                              image2.source = (atmospheresHandler.variant == "dark") ?   "/icons/icon-m-pause.svg":"/icons_black/pause_black.png"
                               playedStatus=true

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
                    playlistView.currentIndex++
                    var index = playlistView.currentIndex
                    var path = playlistModel.get(index)["path"]
                    mediaPlayer.source = path

                }
            }
        }
    }

    Text {
        id: titleAudio
        x: 8
        y: -41
        width: 106
        height: 40
         color: (atmospheresHandler.variant == "dark") ? "white" : "black"
        text: qsTr("Music")
        anchors.left: parent.left
        anchors.top: parent.top
        font.pixelSize: 33
        horizontalAlignment: Text.AlignLeft
        anchors.topMargin: 0
        anchors.leftMargin: 8
        font.bold: false
        font.family: "lato"
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

           if(playedStatus==true){
               //if(!playlistView.currentIndex==playlistView.count++){
           playlistView.currentIndex++
           var index = playlistView.currentIndex
           var path = playlistModel.get(index)["path"]
           mediaPlayer.source = path
           mediaPlayer.play()
           playedStatus=false
       }
       }
       onPlaying:{
   //mediaPlayer.p
       }
    }

    ScrollView {
        id: scroll
        anchors.fill: parent
        anchors.bottomMargin: 57
        anchors.topMargin: 42
        //Layout.fillWidth: true
        //Layout.fillHeight: true
        // flickableItem.interactive: true

        ListView {
            id: playlistView
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 42
            anchors.bottomMargin: 15
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
                       image2.source = (atmospheresHandler.variant == "dark") ? "/icons_black/play.png":"/icons/icon-m-play.svg"
                    mediaPlayer.source = path

               }
            }
        }
    }
  Player {
    id: player
  }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}D{i:9}
}
##^##*/
