import QtQuick
import qs.modules

Rectangle {
    id: card

    required property var notification

    width: 360
    height: col.implicitHeight + 20
    radius: 10
    color: Qt.rgba(
        Colors.background.r,
        Colors.background.g,
        Colors.background.b,
        0.92
    )

    border.color: Qt.rgba(
        Colors.color8.r,
        Colors.color8.g,
        Colors.color8.b,
        0.5
    )
    border.width: 1

    Rectangle {
        width: 3
        height: parent.height - 16
        radius: 2
        anchors {
            left: parent.left
            leftMargin: 4
            verticalCenter: parent.verticalCenter
        }
        color: notification.urgency === "critical" ? Colors.color1
             : notification.urgency === "low"      ? Colors.color8
             :                                       Colors.accent
    }

    Column {
        id: col
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: 16
            rightMargin: 12
            topMargin: 10
        }
        spacing: 3

        // Имя приложения
        Text {
            text: notification.appName
            color: Colors.accent
            font.pixelSize: 11
            font.weight: Font.Medium
            width: parent.width
            elide: Text.ElideRight
            visible: notification.appName !== ""
        }

        // Заголовок
        Text {
            text: notification.summary
            color: Colors.foreground
            font.pixelSize: 13
            font.weight: Font.Bold
            width: parent.width
            elide: Text.ElideRight
            bottomPadding: 2
        }

        // Тело
        Text {
            text: notification.body
            color: Colors.color7
            font.pixelSize: 12
            width: parent.width
            wrapMode: Text.WordWrap
            maximumLineCount: 4
            elide: Text.ElideRight
            visible: notification.body !== ""
        }
    }
}
