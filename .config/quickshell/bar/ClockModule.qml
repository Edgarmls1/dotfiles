import Quickshell
import QtQuick

// clique esquerdo alterna hora / data
// clique direito abre o calendário
BarText {
    signal calendarRequested

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    text: UiState.showDate
        ? `[${Qt.formatDateTime(clock.date, "dd|MM|yy")}]`
        : `[${Qt.formatDateTime(clock.date, "HH:mm")}]`

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: ev => {
            if (ev.button === Qt.RightButton)
                calendarRequested();
            else
                UiState.showDate = !UiState.showDate;
        }
    }
}
