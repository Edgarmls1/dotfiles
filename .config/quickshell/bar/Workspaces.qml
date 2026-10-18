import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

// workspaces do monitor informado
RowLayout {
    id: row
    required property var monitor
    spacing: 0

    Repeater {
        model: Array.from(Hyprland.workspaces.values)
            .filter(w => w.id > 0 && w.monitor === row.monitor)
            .sort((a, b) => a.id - b.id)

        delegate: Rectangle {
            id: ws
            required property var modelData

            // workspace ativo DESTE monitor (não o global)
            readonly property bool active: row.monitor?.activeWorkspace === modelData
            readonly property bool empty: modelData.toplevels.values.length === 0

            Layout.fillHeight: true
            implicitWidth: label.implicitWidth + 12
            color: (active || empty) ? Theme.fg : "transparent"
            opacity: empty ? 0.5 : 1

            Text {
                id: label
                anchors.centerIn: parent
                // 1-9 e 11-19 -> 一..九 (10 -> 十)
                text: "一二三四五六七八九十"[(ws.modelData.id - 1) % 10]
                color: (ws.active || ws.empty) ? Theme.bg : Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: 14
                font.weight: Font.Bold
            }

            MouseArea {
                anchors.fill: parent
                onClicked: ws.modelData.activate()
            }
        }
    }
}
