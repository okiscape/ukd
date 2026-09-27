import QtQuick
import Quickshell
import qs.modules
import Quickshell.Services.Notifications

ShellRoot {
    PanelWindow {
        id: root

        anchors {
            top: true
            left: true
            right: true
        }

        property int barHeight: 30

        implicitHeight: barHeight
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

    Notifications {}
}
