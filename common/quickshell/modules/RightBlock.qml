import QtQuick
import Quickshell.Io
import qs.modules

Rectangle {
    id: root

    property real collapsedWidth: 260
    property real expandedWidth: 500

    property int cpuUsage: 0
    property int cpuTemp: 0
    property int ramUsagePct: 0
    property int swapUsagePct: 0
    property int batteryPct: -1
    property string batteryStatus: ""
    property string netStatus: "none"

    width: hoverHandler.hovered ? expandedWidth : collapsedWidth

    bottomLeftRadius: 20
    color: Colors.background
    clip: true

    Behavior on width {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    Process {
        id: metricsProc
        command: [
            "sh", "-c",
            "cpu=$(LANG=C top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}' | cut -d. -f1); cpu=${cpu:-0}; " +
            "temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{print int($1/1000)}'); temp=${temp:-0}; " +
            "ram=$(free | awk '/Mem:/ {print int($3/$2 * 100)}'); ram=${ram:-0}; " +
            "swap=$(free | awk '/Swap:/ {if ($2 > 0) print int($3/$2 * 100); else print 0}'); swap=${swap:-0}; " +
            "batdir=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n1); " +
            "if [ -n \"$batdir\" ]; then " +
            "  bat=$(cat \"$batdir/capacity\" 2>/dev/null); bat=${bat:--1}; " +
            "  batstat=$(tr -d ' \\n' < \"$batdir/status\" 2>/dev/null); batstat=${batstat:-Unknown}; " +
            "else bat=-1; batstat=none; fi; " +
            "iface=$(ip route show default 2>/dev/null | awk '{print $5; exit}'); " +
            "if [ -z \"$iface\" ]; then net=none; " +
            "elif echo \"$iface\" | grep -q '^wl'; then net=wifi; " +
            "else net=wired; fi; " +
            "echo \"$cpu $temp $ram $swap $bat $batstat $net\""
        ]

        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(" ");
                if (parts.length >= 7) {
                    root.cpuUsage = parseInt(parts[0]) || 0;
                    root.cpuTemp = parseInt(parts[1]) || 0;
                    root.ramUsagePct = parseInt(parts[2]) || 0;
                    root.swapUsagePct = parseInt(parts[3]) || 0;
                    root.batteryPct = parseInt(parts[4]);
                    root.batteryStatus = parts[5];
                    root.netStatus = parts[6];
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

    Row {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        padding: 10
        spacing: 14

        MetricItem {
            anchors.verticalCenter: parent.verticalCenter
            label: "CPU"
            value: root.cpuUsage
            barColor: Colors.color6
        }

        MetricItem {
            anchors.verticalCenter: parent.verticalCenter
            label: "RAM"
            value: root.ramUsagePct
            barColor: Colors.color6
        }

        MetricItem {
            anchors.verticalCenter: parent.verticalCenter
            label: "SWP"
            value: root.swapUsagePct
            barColor: Colors.color6
            opacity: root.swapUsagePct > 0 ? 1.0 : 0.5
        }

        MetricItem {
            anchors.verticalCenter: parent.verticalCenter
            label: "AC"
            value: root.batteryPct < 0 ? 0 : root.batteryPct
            barColor: root.batteryStatus === "Charging" ? Colors.color2 : Colors.color6
            visible: root.batteryPct >= 0
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.cpuTemp + "°C"
            color: Colors.color6
            font.pixelSize: 12
        }

        Text {
            id: netIcon
            anchors.verticalCenter: parent.verticalCenter
            text: root.netStatus === "wifi" ? "\uf1eb"
                : root.netStatus === "wired" ? "\uf6ff"
                : "\uf695"
            color: root.netStatus === "none" ? Colors.color1 : Colors.color6
            font.pixelSize: 14

            HoverHandler {
                id: netHover
            }

            HoverTooltip {
                target: netIcon
                edge: "bottom"
                shown: netHover.hovered
                text: root.netStatus === "wifi" ? "Wi-Fi"
                    : root.netStatus === "wired" ? "Ethernet"
                    : "No connection"
            }
        }
    }

    HoverHandler {
        id: hoverHandler
    }
}
