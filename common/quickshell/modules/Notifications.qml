import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules

PanelWindow {
    id: win

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
    }

    color: "transparent"
    implicitWidth: 360
    implicitHeight: notificationColumn.implicitHeight + 50

    exclusionMode: ExclusionMode.Ignore

    mask: Region {
        Region {
            item: notificationColumn
        }
    }

    Column {
        id: notificationColumn
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 5

        Repeater {
            model: NotificationService.popupList
            NotificationCard {
                required property var modelData
                notification: modelData
                closing: modelData.closing
            }
        }
    }
}
