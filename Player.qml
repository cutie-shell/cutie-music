import QtQuick 2.15
import QtQuick.Controls 2.15
import Cutie 1.0
import QtGraphicalEffects 1.15

Rectangle{
    id: player
    width: view.width
    height: view.height
    color: "#00ffffff"
    property  int dpi: 4

    Image {
        id: image
        x: 83
        width: 234
        height: 236
        anchors.top: parent.top
        source: (atmospheresHandler.variant == "dark") ? "/icons_black/icon-m-music.svg" : "/icons/music.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 58
        sourceSize.height: 800
        sourceSize.width: 800
        fillMode: Image.PreserveAspectFit
    }

    Label {
        id: text1
        x: 143
        text: mediaPlayer.title
        anchors.top: image.bottom
        font.pixelSize: 32
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.topMargin: -2
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Raleway"
        color: (atmospheresHandler.variant == "dark") ? "white" : "black"
    }

    Rectangle {
        id: slideritem
        y: 824
        height: 53
        color: "#00ffffff"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.bottomMargin: 50

        Slider {
            id: root
            // z: 3
            property string valueText: ""
            property string label: ""
            property real minimumValue: 0.0
            property real maximumValue: mediaPlayer.duration
             value: mediaPlayer.duration

             property bool sync: false
             anchors.fill: parent

                               onValueChanged: {
                                   if (!sync)
                                       mediaPlayer.seek(value)
                               }

                               Connections {
                                   target: mediaPlayer
                                   onPositionChanged: {
                                       root.sync = true
                                       root.value = mediaPlayer.position
                                       root.sync = false
                                   }
                               }

            from: minimumValue
            to: maximumValue

            leftPadding: 2*5
            rightPadding: 2*5
            topPadding: 1*5
            bottomPadding: 1*5

            background: Rectangle {
                x: root.leftPadding + 3 * 5
                y: root.topPadding + 3.5 * 5
                height: 5 / 2
                width: root.availableWidth - root.rightPadding - root.leftPadding
                radius: 5 / 4
                color: (atmospheresHandler.variant == "dark") ? "#8fffffff" : "#60000000"
            }

            handle: RadialGradient {
                x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
                y: root.topPadding + root.availableHeight / 2 - height / 2
                gradient: Gradient {
                    GradientStop { position: 0.0; color:(atmospheresHandler.variant == "dark") ? "#ffffff" : "#000000" }
                    GradientStop { position: 0.5; color: "transparent" }
                }
                width: 5 * 6
                height: 5 * 6
            }


        }
    }

       // id: playerSlate
        state: "closed"
        states: [
            State{
                name: "closed"
                PropertyChanges { target: player; opacity: 0; y: view.height }
                PropertyChanges {
                    target: scroll
                   opacity: 1
                    enabled: true

                }
                PropertyChanges {
                    target: titleM
                   opacity: 1
                    enabled: true

                }
                PropertyChanges {
                    target: rectangleM
                   opacity: 1
                    enabled: true

                }
            },
            State{
                name: "unopened"
                PropertyChanges { target: player; opacity: 0; y: view.height }
            },
            State {
                name: "opened"
                PropertyChanges { target: player; opacity: 1; y: 0 }
                PropertyChanges {
                    target: scroll
                      opacity: 0
                    enabled: false

                }
                PropertyChanges {
                    target: titleM
                   opacity: 0
                    enabled: false

                }
                PropertyChanges {
                    target: rectangleM
                   opacity: 0
                    enabled: false

                }
            }

]

          transitions: [
 Transition {
                       to: "opened"
                     NumberAnimation { target: player; properties: "opacity"; duration: 300; easing.type: Easing.InOutQuad; }
                  },
                  Transition {
                       to: "closed"
                      NumberAnimation { target: player; properties: "opacity"; duration: 300; easing.type: Easing.InOutQuad; }
                  }
]



}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}D{i:4}D{i:3}
}
##^##*/
