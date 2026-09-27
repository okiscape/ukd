import QtQuick
import Quickshell.Io
import qs.modules

Rectangle {
    id: root

    property int cpuUsage: 0
    property int cpuTemp: 0
    property int ramUsagePct: 0
    property int swapUsagePct: 0
    property int batteryPct: -1
    property string batteryStatus: ""
    property string netStatus: "none"
    property int volumePct: 0
    property int brightnessPct: 0

    property real expandedWidth: rightRow.implicitWidth
    property real collapsedWidth: calcWidth([
        cpuMetric,
        ramMetric,
        swapMetric,
        root.batteryPct >= 0 ? batteryMetric : null,
        tempMetric,
        netMetric,
        volumeMetric,
        brightnessMetric
    ])

    function calcWidth(items) {
        let visibleItems = items.filter(item => item && item.visible);
        if (visibleItems.length === 0) return 0;

        let sumWidth = visibleItems.reduce((acc, item) => acc + item.implicitWidth, 0);
        let gaps = visibleItems.length - 1;
        let totalSpacing = gaps * rightRow.spacing;
        let totalPadding = rightRow.padding * 2;

        return sumWidth + totalSpacing + totalPadding;
    }

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
        id: cmdProc
        function exec(cmd) {
            command = ["sh", "-c", cmd];
            running = true;
        }
    }

    Process {
        id: metricsProc
        command: [
            "sh", "-c",
            "cpu=$(LANG=C top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}' | cut -d. -f1); cpu=${cpu:-0}; " +
            "temp=0; " +
            "for zone in /sys/class/thermal/thermal_zone*/temp; do " +
            "  [ -r \"$zone\" ] && { t=$(cat \"$zone\" 2>/dev/null | awk '{print int($1/1000)}'); [ \"$t\" -gt 0 ] && [ \"$t\" -lt 150 ] && temp=$t && break; }; " +
            "done; " +
            "[ \"$temp\" -eq 0 ] && " +
            "for hwmon in /sys/class/hwmon/hwmon*/temp*_input; do " +
            "  [ -r \"$hwmon\" ] && { t=$(cat \"$hwmon\" 2>/dev/null | awk '{print int($1/1000)}'); [ \"$t\" -gt 0 ] && [ \"$t\" -lt 150 ] && temp=$t && break; }; " +
            "done; " +
            "[ \"$temp\" -eq 0 ] && command -v sensors >/dev/null && " +
            "temp=$(sensors 2>/dev/null | grep -i 'core\\|package\\|cpu\\|temp' | head -1 | grep -o '+\\?[0-9]\\+' | head -1); temp=${temp:-0}; " +
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
            "vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print int($2*100)}'); vol=${vol:-0}; " +
            "bright=$(brightnessctl -m 2>/dev/null | cut -d, -f4 | tr -d '%'); bright=${bright:-0}; " +
            "echo \"$cpu $temp $ram $swap $bat $batstat $net $vol $bright\""
        ]

        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(" ");
                if (parts.length >= 9) {
                    root.cpuUsage = parseInt(parts[0]) || 0;
                    root.cpuTemp = parseInt(parts[1]) || 0;
                    root.ramUsagePct = parseInt(parts[2]) || 0;
                    root.swapUsagePct = parseInt(parts[3]) || 0;
                    root.batteryPct = parseInt(parts[4]);
                    root.batteryStatus = parts[5];
                    root.netStatus = parts[6];
                    root.volumePct = parseInt(parts[7]) || 0;
                    root.brightnessPct = parseInt(parts[8]) || 0;
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
        id: rightRow
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        padding: 10
        spacing: 14

        MetricItem {
            id: cpuMetric
            anchors.verticalCenter: parent.verticalCenter
            label: "CPU"
            value: root.cpuUsage
            barColor: Colors.color6
            tooltipText: "CPU " + root.cpuUsage + "% · " + root.cpuTemp + "°C"
        }

        MetricItem {
            id: ramMetric
            anchors.verticalCenter: parent.verticalCenter
            label: "RAM"
            value: root.ramUsagePct
            barColor: Colors.color6
        }

        MetricItem {
            id: swapMetric
            anchors.verticalCenter: parent.verticalCenter
            label: "SWP"
            value: root.swapUsagePct
            barColor: Colors.color6
            opacity: root.swapUsagePct > 0 ? 1.0 : 0.5
        }

        MetricItem {
            id: batteryMetric
            anchors.verticalCenter: parent.verticalCenter
            label: "AC"
            value: root.batteryPct < 0 ? 0 : root.batteryPct
            barColor: root.batteryStatus === "Charging" ? Colors.color2 : Colors.color6
            visible: root.batteryPct >= 0
            tooltipText: root.batteryPct + "% · " + root.batteryStatus
        }

        Text {
            id: tempMetric
            anchors.verticalCenter: parent.verticalCenter
            text: root.cpuTemp + "°C"
            color: Colors.color6
            font.pixelSize: 12
            font.family: "Monospace"
        }

        Text {
            id: netMetric
            anchors.verticalCenter: parent.verticalCenter
            text: root.netStatus === "wifi" ? "\uf1eb"
                : root.netStatus === "wired" ? "\uf6ff"
                : "\uf695"
            color: root.netStatus === "none" ? Colors.color1 : Colors.color6
            font.pixelSize: 14
        }

        Item {
            id: volumeMetric
            implicitWidth: volMetric.implicitWidth
            implicitHeight: volMetric.implicitHeight
            anchors.verticalCenter: parent.verticalCenter

            MetricItem {
                id: volMetric
                label: "VOL"
                value: root.volumePct
                barColor: Colors.color6
            }

            MouseArea {
                anchors.fill: parent
                onWheel: wheel => {
                    if (wheel.angleDelta.y > 0) {
                        cmdProc.exec("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+");
                    } else {
                        cmdProc.exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-");
                    }
                    metricsProc.running = true;
                }
                onClicked: {
                    cmdProc.exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle");
                    metricsProc.running = true;
                }
            }
        }

        Item {
            id: brightnessMetric
            implicitWidth: brtMetric.implicitWidth
            implicitHeight: brtMetric.implicitHeight
            anchors.verticalCenter: parent.verticalCenter

            MetricItem {
                id: brtMetric
                label: "BRT"
                value: root.brightnessPct
                barColor: Colors.color6
                tooltipText: "Brightness: " + root.brightnessPct + "%"
            }

            MouseArea {
                anchors.fill: parent
                onWheel: wheel => {
                    if (wheel.angleDelta.y > 0) {
                        cmdProc.exec("brightnessctl set +5%");
                    } else {
                        cmdProc.exec("brightnessctl set 5%-");
                    }
                    metricsProc.running = true;
                }
            }
        }
    }

    HoverHandler {
        id: hoverHandler
    }
}
