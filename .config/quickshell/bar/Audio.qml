pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: sink?.audio ?? null

    // emitido quando o volume/mute muda por qualquer meio (teclas, pavucontrol, scroll...)
    signal volumeTouched
    property bool volReady: false

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Timer {
        running: true
        interval: 2000
        onTriggered: root.volReady = true   // ignora as mudanças iniciais ao carregar
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio ?? null
        function onVolumeChanged() { if (root.volReady) root.volumeTouched(); }
        function onMutedChanged() { if (root.volReady) root.volumeTouched(); }
    }
}
