import QtQuick
import Quickshell.Io
import qs.modules

Rectangle {
    id: root

    property real collapsedWidth: 205
    property real expandedWidth: 600
    property var currentDate: new Date()
    property string mediaArtist: ""
    property string mediaTitle: ""
    property string mediaStatus: "Stopped"
    property bool hasPlayer: false

    readonly property real baseWidth: timeText.implicitWidth + dateText.implicitWidth + 44
    readonly property real trackTextWidth: trackText.implicitWidth
    readonly property real mediaWidth: root.hasPlayer ? (baseWidth + trackTextWidth + 8) : 0

    width: hoverHandler.hovered ? (root.hasPlayer ? Math.max(mediaWidth, expandedWidth) : expandedWidth) : (root.hasPlayer ? Math.max(mediaWidth, collapsedWidth) : collapsedWidth)


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
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentDate = new Date()
    }

    Process {
        id: playerctlProc
        command: ["playerctl", "-a", "metadata", "--format", "{{status}}|{{artist}}|{{title}}"]

        stdout: SplitParser {
            onRead: data => {
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

    Timer {
        interval: 500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: playerctlProc.running = true
    }

    function formatTrackInfo(artist, title) {
        if (!artist && !title) return "";
        let maxArtist = 150;
        let maxTotal = 50;
        let divider = " - ";
        let a = artist ? artist : "";
        let t = title ? title : "";
        if (a.length > maxArtist) a = a.slice(0, maxArtist - 1) + "…";
        let remaining = maxTotal - a.length - divider.length;
        if (t.length > remaining) t = t.slice(0, remaining - 1) + "…";
        return a + (a && t ? divider : "") + t;
    }

    Row {
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
            text: Qt.formatDate(root.currentDate, "dd.MM.yyyy")
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            font.family: "Monospace"
            opacity: 0.7
            color: Colors.color6
        }

        Text {
            id: trackText
            text: root.hasPlayer ? formatTrackInfo(root.mediaArtist, root.mediaTitle) : ""
            font.pixelSize: 13
            font.family: "Monospace"
            color: Colors.color6
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
            visible: root.hasPlayer

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
            }
        }

        Process { id: prevProc; command: ["playerctl", "previous"] }
        Process { id: playPauseProc; command: ["playerctl", "play-pause"] }
        Process { id: nextProc; command: ["playerctl", "next"] }
    }

    HoverHandler {
        id: hoverHandler
    }
}
