import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts

// grupo expansível (rede, bluetooth, cpu/mem, música)
// expande para a esquerda do botão [<] / [>]
Item {
    id: group

    property bool expanded: false
    signal mediaClicked

    Layout.fillHeight: true
    clip: true
    implicitWidth: expanded ? groupRow.implicitWidth : 0
    Behavior on implicitWidth {
        NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
    }

    RowLayout {
        id: groupRow
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        spacing: 0

        // network
        BarText {
            text: Stats.netState === "wired" ? "[WIRED]"
                : Stats.netState === "wifi" ? "[WIFI]"
                : "[NO LAN]"
            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached([Theme.term, "-e", "gazelle"])
            }
        }

        // bluetooth (some quando o adaptador está desligado)
        BarText {
            readonly property int conn: Array.from(Bluetooth.devices.values)
                .filter(d => d.connected).length
            visible: Bluetooth.defaultAdapter?.enabled ?? false
            text: conn > 0 ? `[${conn}]` : "[]"
            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached([Theme.term, "-e", "bluetui"])
            }
        }

        // cpu / mem (elemento único)
        // clique esquerdo: alterna CPU <-> MEM
        // clique direito: abre o btop
        BarText {
            text: UiState.resMode === "cpu"
                ? `[CPU ${Stats.cpu}%]`
                : `[MEM ${Stats.memPct}%]`
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: ev => {
                    if (ev.button === Qt.RightButton)
                        Quickshell.execDetached([Theme.term, "-e", "btop"])
                    else
                        UiState.resMode = UiState.resMode === "cpu" ? "mem" : "cpu";
                }
            }
        }
    }
}
