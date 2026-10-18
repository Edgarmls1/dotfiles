import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: bar
    required property var modelData
    screen: modelData

    // monitor do Hyprland correspondente a esta barra
    readonly property var monitor: Hyprland.monitorFor(modelData)

    // grupo expansível (rede, bluetooth, cpu/mem, música)
    property bool expanded: false
    onExpandedChanged: {
        if (!expanded)
            mediaPopup.visible = false;
    }

    anchors {
        bottom: true
        left: true
        right: true
    }
    implicitHeight: 24
    color: Theme.bg

    // ===== ESQUERDA: workspaces =====
    Workspaces {
        monitor: bar.monitor
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
    }

    // ===== DIREITA: módulos =====
    RowLayout {
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        spacing: 0

        ExpandGroup {
            expanded: bar.expanded
            onMediaClicked: mediaPopup.visible = !mediaPopup.visible
        }

        // botão que expande/recolhe o grupo
        BarText {
            text: bar.expanded ? "[>]" : "[<]"
            MouseArea {
                anchors.fill: parent
                onClicked: bar.expanded = !bar.expanded
            }
        }

        VolumeModule {}
        ClockModule {
            onCalendarRequested: calendarPopup.visible = !calendarPopup.visible
        }
    }

    // ===== POPUP: Media Player =====
    MediaPopup {
        id: mediaPopup
        barWindow: bar
    }

    // ===== POPUP: Calendário =====
    CalendarPopup {
        id: calendarPopup
        barWindow: bar
    }
}
