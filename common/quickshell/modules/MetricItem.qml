import QtQuick
import qs.modules

Column {
    id: root

    property string label: ""
    property int value: 0
    property color barColor: Colors.color5
    property string tooltipEdge: "bottom"
    property string tooltipText: ""
    property real barTrackWidth: 28

    spacing: 3

    MetricBar {
        id: bar
        anchors.horizontalCenter: parent.horizontalCenter
        value: root.value
        fillColor: root.barColor
        trackWidth: root.barTrackWidth
    }

    Text {
        id: labelText
        anchors.horizontalCenter: parent.horizontalCenter
        text: hoverHandler.hovered ? root.value + "%" : root.label
        color: Colors.color6
        font.pixelSize: 10
    }

    HoverHandler {
        id: hoverHandler
    }

    HoverTooltip {
        target: root
        edge: root.tooltipEdge
        shown: hoverHandler.hovered
        text: root.tooltipText !== ""
            ? root.tooltipText
            : root.label + " " + root.value + "%"
    }
}
