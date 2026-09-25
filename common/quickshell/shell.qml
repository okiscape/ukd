import QtQuick
import Quickshell
import qs.modules

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 30
    color: "transparent"

    mask: Region {
        Region {
            item: leftBlock
        }

        Region {
            item: rightBlock
        }
    }

    Item {
        anchors.fill: parent

        LeftBlock {
            id: leftBlock

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        RightBlock {
            id: rightBlock

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }
    }
}
