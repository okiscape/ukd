import QtQuick
import qs.modules

Rectangle {
    id: root

    property real collapsedWidth: 200
    property real expandedWidth: 500

    property var currentDate: new Date()

    width: hoverHandler.hovered ? expandedWidth : collapsedWidth
    bottomRightRadius: 20
    clip: true

    color: Colors.background

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentDate = new Date()
    }

    Behavior on width {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    Row {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        padding: 10
        spacing: 8

        Text {
            text: Qt.formatTime(root.currentDate, "hh:mm:ss")
            font.pixelSize: 16
            font.weight: 700
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.color14
        }

        Text {
            text: Qt.formatDate(root.currentDate, "dd.MM.yyyy")
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.7
            color: Colors.color6
        }
    }

    HoverHandler {
        id: hoverHandler
    }
}
