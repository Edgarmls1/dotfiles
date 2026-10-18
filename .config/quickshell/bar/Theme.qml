pragma Singleton
import Quickshell
import QtQuick

// valores vindos do config.js
Singleton {
    // cores
    readonly property color bg: "#181818"
    readonly property color bgDark: "#000000"
    readonly property color fg: "#999999"
    readonly property color muted: "#444b6a"
    readonly property color cyan: "#0db9d7"
    readonly property color purple: "#8888ff"
    readonly property color red: "#a35b5b"
    readonly property color yellow: "#ffd866"
    readonly property color blue: "#7aa2f7"

    // fonte
    readonly property string fontFamily: "Hack Nerd Font"
    readonly property int fontSize: 12

    // notificações
    readonly property int notifTimeout: 5000   // ms

    // resto da shell
    readonly property string term: "wezterm"
    readonly property int popupMargin: 20
}
