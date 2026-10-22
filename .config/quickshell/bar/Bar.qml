import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: bar
    required property var modelData
    screen: modelData

    readonly property var monitor: Hyprland.monitorFor(modelData)

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

    Workspaces {
        monitor: bar.monitor
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
    }

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

    MediaPopup {
        id: mediaPopup
        barWindow: bar
    }

    CalendarPopup {
        id: calendarPopup
        barWindow: bar
    }
}
