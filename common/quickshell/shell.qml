import QtQuick
import QtQuick.Layouts
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
    color: "#1e1e2e"

    RowLayout {
        anchors.fill: parent

        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 8

        LeftBlock {
            Layout.alignment: Qt.AlignVCenter
        }

        Item {
            Layout.fillWidth: true
        }

        RightBlock {
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
