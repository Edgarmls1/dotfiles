import QtQuick

// pulseaudio / pipewire
BarText {
    id: vol
    readonly property var audio: Audio.audio

    text: !audio ? "[VOL --]"
        : audio.muted ? "[MUTED]"
        : `[VOL ${Math.round(audio.volume * 100)}%]`

    MouseArea {
        anchors.fill: parent
        onClicked: if (vol.audio) vol.audio.muted = !vol.audio.muted
        onWheel: w => {
            if (!vol.audio) return;
            const step = w.angleDelta.y > 0 ? 0.05 : -0.05;
            vol.audio.volume = Math.max(0, Math.min(1.0, vol.audio.volume + step));
        }
    }
}
