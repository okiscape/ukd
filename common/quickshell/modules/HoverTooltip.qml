import QtQuick
import QtQuick.Window
import qs.modules

Item {
    id: root

    property Item target: null
    property string text: ""
    property string edge: "bottom"
    property real gap: 6
    property real margin: 4
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

    // mapToItem() не создаёт зависимостей, поэтому позиция тултипа считается
    // один раз (до того как Row посчитал свою высоту) и больше не обновляется.
    // Этот "хэш" читает x/y/width/height всех предков target - при изменении их
    // геометрии биндинги позиции пересчитываются.
    readonly property real _deps: {
        var sum = 0;
        for (var it = target; it; it = it.parent)
            sum += it.x * 3 + it.y * 5 + it.width * 7 + it.height * 11;
        return sum;
    }

    Binding {
        target: root
        property: "x"
        value: {
            if (!root.target || !root.parent) return 0;
            root._deps; // см. _deps - без этого позиция не обновляется
            var pos = root.target.mapToItem(root.parent, root.target.width / 2, 0);
            var x = pos.x - root.width / 2;
            // не даём тултипу уехать за края экрана
            return Math.max(root.margin,
                Math.min(root.parent.width - root.width - root.margin, x));
        }
    }

    Binding {
        target: root
        property: "y"
        value: {
            if (!root.target || !root.parent) return 0;
            root._deps;
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
