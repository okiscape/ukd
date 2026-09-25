import QtQuick

Rectangle {
    id: root

    property real collapsedWidth: 160
    property real expandedWidth: 300

    width: hoverHandler.hovered ? expandedWidth : collapsedWidth

    bottomRightRadius: 20

    clip: true

    Behavior on width {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    Row {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        padding: 10      
        spacing: 8

        Text {
            text: "HH:MM:SS dd.mm.yyyy"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    HoverHandler {
        id: hoverHandler
    }
}