import QtQuick
import qs.modules

Item {
    id: root

    property int value: 0
    property real trackWidth: 28
    property real trackHeight: 4
    property color fillColor: Colors.color6
    property color trackColor: Colors.color1

    width: trackWidth
    height: trackHeight

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: root.trackColor
    }

    Rectangle {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        width: parent.width * Math.max(0, Math.min(100, root.value)) / 100
        radius: height / 2
        color: root.fillColor

        Behavior on width {
            NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
        }
    }
}
