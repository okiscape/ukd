import QtQuick
import Quickshell.Io
import qs.modules

Rectangle {
    id: root

    property var currentDate: new Date()
    property string mediaArtist: ""
    property string mediaTitle: ""
    property string mediaStatus: "Stopped"
    property bool hasPlayer: false
    property real mediaPosition: 0
    property real mediaDuration: 0

    property real expandedWidth: leftRow.implicitWidth
    property real collapsedWidth: calcWidth([
        timeText,
        dateText,
        hasPlayer?playerMeta:null,
        hasPlayer?playerPos:null
    ])

    width: hoverHandler.hovered ? expandedWidth : collapsedWidth


    function calcWidth(items) {
        let visibleItems = items.filter(item => item && item.visible);
        if (visibleItems.length === 0) return 0;

        let sumWidth = visibleItems.reduce((acc, item) => acc + item.implicitWidth, 0);
        let gaps = visibleItems.length - 1;
        let totalSpacing = gaps * leftRow.spacing;
        let totalPadding = leftRow.padding * 2;

        return sumWidth + totalSpacing + totalPadding;
    }


    Behavior on width {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    bottomRightRadius: 20
    clip: true
    color: Colors.background

    Timer {
        interval: 50
        running: true
        repeat: true
        onTriggered: root.currentDate = new Date()
    }

    Process {
        id: playerctlProc
        command: ["playerctl", "-a", "metadata", "--format", "{{status}}|{{artist}}|{{title}}"]

        stderr: SplitParser {
            onRead: _ => {
                root.mediaArtist = "";
                root.mediaTitle = "";
                root.mediaStatus = "Stopped";
                root.hasPlayer = false;
            }
        }

        stdout: SplitParser {
            onRead: data => {
                if (!data || !data.trim()) {
                    root.mediaArtist = "";
                    root.mediaTitle = "";
                    root.mediaStatus = "Stopped";
                    root.hasPlayer = false;
                    return;
                }
                let lines = data.trim().split("\n");
                let foundPlaying = false;
                let firstArtist = "";
                let firstTitle = "";
                let firstStatus = "Playing";

                for (let line of lines) {
                    let parts = line.split("|");
                    if (parts.length >= 3) {
                        let status = parts[0];
                        let artist = parts[1];
                        let title = parts[2];
                        if (!firstArtist && artist) firstArtist = artist;
                        if (!firstTitle && title) firstTitle = title;
                        if (!firstStatus || firstStatus === "Stopped") firstStatus = status;
                        if (status === "Playing") {
                            root.mediaArtist = artist;
                            root.mediaTitle = title;
                            root.mediaStatus = status;
                            foundPlaying = true;
                            break;
                        }
                    }
                }
                if (!foundPlaying && (firstArtist || firstTitle)) {
                    root.mediaArtist = firstArtist;
                    root.mediaTitle = firstTitle;
                    root.mediaStatus = firstStatus;
                    root.hasPlayer = true;
                } else if (foundPlaying) {
                    root.hasPlayer = true;
                } else {
                    root.mediaArtist = "";
                    root.mediaTitle = "";
                    root.mediaStatus = "Stopped";
                    root.hasPlayer = false;
                }
            }
        }
    }

    Process {
        id: playerctlPosProc
        command: ["playerctl", "metadata", "--format", "{{position}}|{{mpris:length}}"]

        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split("|");
                if (parts.length >= 2) {
                    let pos = parseFloat(parts[0]);
                    let len = parseFloat(parts[1]);
                    root.mediaPosition = isNaN(pos) ? 0 : pos / 1e6;
                    root.mediaDuration = isNaN(len) ? 0 : len / 1e6;
                }
            }
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            playerctlProc.running = true;
            if (root.hasPlayer) playerctlPosProc.running = true;
        }
    }

    function formatTrackInfo(artist, title) {
        if (!artist && !title) return "";
        let maxArtist = 20;
        let maxTotal = 50;
        let divider = " - ";
        let a = artist ? artist : "";
        let t = title ? title : "";
        if (a.length > maxArtist) a = a.slice(0, maxArtist - 1) + "…";
        let remaining = maxTotal - a.length - divider.length;
        if (t.length > remaining) t = t.slice(0, remaining - 1) + "…";
        return a + (a && t ? divider : "") + t;
    }

    function formatTime(secs, showHours) {
        let s = Math.floor(secs);
        let h = Math.floor(s / 3600);
        let m = Math.floor((s % 3600) / 60);
        let sec = s % 60;
        let mm = String(m).padStart(2, "0");
        let ss = String(sec).padStart(2, "0");
        if (showHours) {
            let hh = String(h).padStart(2, "0");
            return hh + ":" + mm + ":" + ss;
        }
        return mm + ":" + ss;
    }

    Row {
        id: leftRow
        anchors.fill: parent
        padding: 10
        spacing: 12

        Text {
            id: timeText
            text: Qt.formatTime(root.currentDate, "hh:mm:ss")
            font.pixelSize: 16
            font.weight: 700
            font.family: "Monospace"
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.color14
        }

        Text {
            id: dateText
            text: Qt.formatDate(root.currentDate, "ddd dd.MM.yyyy")
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
            font.family: "Monospace"
            opacity: 0.7
            color: Colors.color6
        }

        Column {
            id: playerPos
            anchors.verticalCenter: parent.verticalCenter
            visible: root.hasPlayer

            MetricBar {
                trackWidth: positionText.implicitWidth
                trackHeight: 4
                value: root.mediaDuration > 0
                       ? Math.round(root.mediaPosition / root.mediaDuration * 100)
                       : 0
            }

            Text {
                id: positionText
                readonly property bool showHours: root.mediaDuration >= 3600
                text: formatTime(root.mediaPosition, showHours)
                      + "/"
                      + formatTime(root.mediaDuration, showHours)
                font.pixelSize: 10
                font.family: "Monospace"
                color: Colors.color6
                opacity: 0.6
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            id: playerMeta
            text: root.hasPlayer ? formatTrackInfo(root.mediaArtist, root.mediaTitle) : ""
            font.pixelSize: 13
            font.family: "Monospace"
            color: Colors.color6
            elide: Text.ElideRight

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton | Qt.XButton1 | Qt.XButton2
                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        playPauseProc.running = true;
                    } else if (mouse.button === Qt.RightButton || mouse.button === Qt.XButton2) {
                        nextProc.running = true;
                    } else if (mouse.button === Qt.MiddleButton || mouse.button === Qt.XButton1) {
                        prevProc.running = true;
                    }
                }
                onWheel: (wheel) => {
                    if (wheel.angleDelta.y > 0) {
                        volUpProc.running = true;
                    } else {
                        volDownProc.running = true;
                    }
                }
            }
        }

        Process { id: prevProc;      command: ["playerctl", "previous"]        }
        Process { id: playPauseProc; command: ["playerctl", "play-pause"]      }
        Process { id: nextProc;      command: ["playerctl", "next"]            }
        Process { id: volUpProc;     command: ["playerctl", "volume", "0.01+"] }
        Process { id: volDownProc;   command: ["playerctl", "volume", "0.01-"] }
    }

    HoverHandler {
        id: hoverHandler
    }
}
