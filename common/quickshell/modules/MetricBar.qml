import QtQuick
import qs.modules

// Короткий горизонтальный прогресс-бар. value: 0..100
Item {
    id: root

    property int value: 0
    property real trackWidth: 28
    property real trackHeight: 4
    property color fillColor: Colors.color5
    property color trackColor: Qt.rgba(1, 1, 1, 0.15)

    width: trackWidth
    height: trackHeight

    // фон/трек бара
    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: root.trackColor
    }

    // заполнение, растущее слева направо по мере роста value
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
