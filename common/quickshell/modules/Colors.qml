pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    readonly property string cacheDir:
        Quickshell.env("XDG_CACHE_HOME") ||
        (Quickshell.env("HOME") + "/.cache")

    readonly property FileView hellwalFile: FileView {
        path: root.cacheDir + "/hellwal/colors.json"
        watchChanges: true
        onFileChanged: reload()
    }

    readonly property FileView pywalFile: FileView {
        path: root.cacheDir + "/wal/colors.json"
        watchChanges: true
    }

    readonly property var _data: {
        var hellwalText = hellwalFile.text() || "";
        var pywalText = pywalFile.text() || "";

        var rawText = hellwalText.trim() !== ""
                ? hellwalText
                : pywalText;

        if (rawText.trim() === "")
            return null;

        try {
            return JSON.parse(rawText);
        } catch (e) {
            console.warn("Colors.qml: JSON parse error:", e);
            console.warn("Theme text:", JSON.stringify(rawText));
            return null;
        }
    }


    readonly property color background:
        _data && _data.special && _data.special.background
            ? _data.special.background
            : "#1e1e2e"

    readonly property color foreground:
        _data && _data.special && _data.special.foreground
            ? _data.special.foreground
            : "#000000"

    readonly property color cursor:
        _data && _data.special && _data.special.cursor
            ? _data.special.cursor
            : "#f5e0dc"

    readonly property color color0:
        _data && _data.colors && _data.colors.color0
            ? _data.colors.color0
            : "#45475a"

    readonly property color color1:
        _data && _data.colors && _data.colors.color1
            ? _data.colors.color1
            : "#f38ba8"

    readonly property color color2:
        _data && _data.colors && _data.colors.color2
            ? _data.colors.color2
            : "#a6e3a1"

    readonly property color color3:
        _data && _data.colors && _data.colors.color3
            ? _data.colors.color3
            : "#f9e2af"

    readonly property color color4:
        _data && _data.colors && _data.colors.color4
            ? _data.colors.color4
            : "#89b4fa"

    readonly property color color5:
        _data && _data.colors && _data.colors.color5
            ? _data.colors.color5
            : "#f5c2e7"

    readonly property color color6:
        _data && _data.colors && _data.colors.color6
            ? _data.colors.color6
            : "#94e2d5"

    readonly property color color7:
        _data && _data.colors && _data.colors.color7
            ? _data.colors.color7
            : "#bac2de"

    readonly property color color8:
        _data && _data.colors && _data.colors.color8
            ? _data.colors.color8
            : "#585b70"

    readonly property color color9:
        _data && _data.colors && _data.colors.color9
            ? _data.colors.color9
            : "#f38ba8"

    readonly property color color10:
        _data && _data.colors && _data.colors.color10
            ? _data.colors.color10
            : "#a6e3a1"

    readonly property color color11:
        _data && _data.colors && _data.colors.color11
            ? _data.colors.color11
            : "#f9e2af"

    readonly property color color12:
        _data && _data.colors && _data.colors.color12
            ? _data.colors.color12
            : "#89b4fa"

    readonly property color color13:
        _data && _data.colors && _data.colors.color13
            ? _data.colors.color13
            : "#f5c2e7"

    readonly property color color14:
        _data && _data.colors && _data.colors.color14
            ? _data.colors.color14
            : "#94e2d5"

    readonly property color color15:
        _data && _data.colors && _data.colors.color15
            ? _data.colors.color15
            : "#a6adc8"

    readonly property color accent: color4
}
