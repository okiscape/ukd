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

    // Высота самого бара и доп. место под тултипы, которые рисуются под ним.
    property int barHeight: 30
    property int tooltipSpace: 30

    implicitHeight: barHeight + tooltipSpace
    // Резервируем только полосу бара, иначе окна снизу сдвинутся на всю высоту окна.
    exclusiveZone: barHeight
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
            anchors.top: parent.top
            height: root.barHeight
        }

        RightBlock {
            id: rightBlock

            anchors.right: parent.right
            anchors.top: parent.top
            height: root.barHeight
        }
    }
}
