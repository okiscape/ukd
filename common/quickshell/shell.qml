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

    implicitHeight: 40
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
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
        }

        RightBlock {
            id: rightBlock

            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
