import QtQuick
import qs.modules

// Колонка "подпись + бар" с тултипом по ховеру, показывающим точный процент.
Column {
    id: root

    property string label: ""
    property int value: 0
    property color barColor: Colors.color5
    property string tooltipEdge: "bottom"
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
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.label
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
        text: root.value + "%"
    }
}
