pragma Singleton
import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Singleton {
    readonly property var player: {
        const ps = Array.from(Mpris.players.values);
        return ps.find(p => p.dbusName.toLowerCase().includes("spotify")) ?? null;
    }

    function fmt(sec) {
        const s = Math.max(0, Math.floor(sec));
        return Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0");
    }
}
