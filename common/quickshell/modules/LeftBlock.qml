import QtQuick

Rectangle {
    property real collapsedWidth: 60
    property real expandedWidth: 180

    width: hoverHandler.hovered ? expandedWidth : collapsedWidth
    height: 20

    Behavior on width {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    HoverHandler {
        id: hoverHandler
    }
}
