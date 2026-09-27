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
        left: true
        right: true
    }

    color: "transparent"
    // mask: Region {
    //     Region {
    //         item: popupArea
    //     }
    //     Region {
    //         item: hubHover.hovered ? hubArea : null
    //     }
    // }

    Repeater {
        model: NotificationService.list
        NotificationCard {
            required property var modelData
            notification: modelData
        }
    }
}
