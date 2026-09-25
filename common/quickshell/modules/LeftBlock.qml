import QtQuick

Rectangle {
    id: root

    property real collapsedWidth: 200
    property real expandedWidth: 500

    property var currentDate: new Date()

    width: hoverHandler.hovered ? expandedWidth : collapsedWidth
    bottomRightRadius: 20
    clip: true

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentDate = new Date()
    }

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
            text: Qt.formatTime(root.currentDate, "hh:mm:ss")
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: Qt.formatDate(root.currentDate, "dd.MM.yyyy")
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.5
        }
    }

    HoverHandler {
        id: hoverHandler
    }
}
