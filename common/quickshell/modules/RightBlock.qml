import QtQuick
import Quickshell.Io
import qs.modules

Rectangle {
    id: root

    property real collapsedWidth: 250
    property real expandedWidth: 500

    property int cpuUsage: 0
    property int cpuTemp: 0
    property int ramUsagePct: 0
    property int swapUsagePct: 0

    width: hoverHandler.hovered ? expandedWidth : collapsedWidth

    bottomLeftRadius: 20
    color: Colors.color8
    clip: true

    Behavior on width {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    Row {
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        padding: 10
        spacing: 8
        anchors.right: parent.right

        Process {
            id: metricsProc
            command: [
                "sh", "-c",
                "cpu=$(LANG=C top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}' | cut -d. -f1); " +
                "temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{print int($1/1000)}' || echo 0); " +
                "ram=$(free | awk '/Mem:/ {print int($3/$2 * 100)}'); " +
                "swap=$(free | awk '/Swap:/ {if ($2 > 0) print int($3/$2 * 100); else print 0}'); " +
                "echo \"$cpu $temp $ram $swap\""
            ]

            stdout: SplitParser {
                onRead: data => {
                    console.log(data)
                    let parts = data.trim().split(" ");
                    if (parts.length >= 4) {
                        root.cpuUsage = parseInt(parts[0]) || 0;
                        root.cpuTemp = parseInt(parts[1]) || 0;
                        root.ramUsagePct = parseInt(parts[2]) || 0;
                        root.swapUsagePct = parseInt(parts[3]) || 0;
                    }
                }
            }
        }

        Timer {
            interval: 2000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: metricsProc.running = true
        }

        Text {
            text: `CPU: ${root.cpuUsage}% (${root.cpuTemp}°C)`
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.color5
        }

        Text {
            text: `RAM: ${root.ramUsagePct}%`
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.color5
        }

        Text {
            text: `SWAP: ${root.swapUsagePct}%`
            anchors.verticalCenter: parent.verticalCenter
            opacity: root.swapUsagePct > 0 ? 1.0 : 0.5
            color: Colors.color5
        }
    }

    HoverHandler {
        id: hoverHandler
    }
}
