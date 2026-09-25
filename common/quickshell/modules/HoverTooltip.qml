import QtQuick
import QtQuick.Window
import qs.modules

Item {
    id: root

    property Item target: null
    property string text: ""
    property string edge: "bottom"
    property real gap: 6
    property bool shown: false
    property Item overlayParent: null

    parent: overlayParent
        ? overlayParent
        : (target && target.Window.window ? target.Window.window.contentItem : (target ? target.parent : null))

    z: 9999
    visible: opacity > 0
    opacity: shown ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

    width: bg.implicitWidth
    height: bg.implicitHeight

    Binding {
        target: root
        property: "x"
        value: {
            if (!root.target || !root.parent) return 0;
            var pos = root.target.mapToItem(root.parent, root.target.width / 2, 0);
            return pos.x - root.width / 2;
        }
    }

    Binding {
        target: root
        property: "y"
        value: {
            if (!root.target || !root.parent) return 0;
            var pos = root.target.mapToItem(root.parent, 0, 0);
            return root.edge === "bottom"
                ? pos.y + root.target.height + root.gap
                : pos.y - root.height - root.gap;
        }
    }

    Rectangle {
        id: bg
        implicitWidth: label.implicitWidth + 16
        implicitHeight: label.implicitHeight + 8
        radius: 6
        color: Colors.color0
        border.width: 1
        border.color: Colors.color8

        Text {
            id: label
            anchors.centerIn: parent
            text: root.text
            color: Colors.color5
            font.pixelSize: 11
        }
    }
}
