import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PopupWindow {
    id: popup

    // janela da barra à qual o popup é ancorado
    required property var barWindow

    // mês exibido (independente do mês atual, para navegar)
    property int viewYear: 0
    property int viewMonth: 0
    readonly property int firstWeekday: new Date(viewYear, viewMonth, 1).getDay()   // 0 = domingo

    readonly property var monthNames: [
        "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
        "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    ]
    readonly property var weekdayNames: ["D", "S", "T", "Q", "Q", "S", "S"]

    function goToToday() {
        const d = clock.date;
        viewYear = d.getFullYear();
        viewMonth = d.getMonth();
    }
    function shift(n) {
        const d = new Date(viewYear, viewMonth + n, 1);
        viewYear = d.getFullYear();
        viewMonth = d.getMonth();
    }

    visible: false
    onVisibleChanged: if (visible) goToToday()
    color: "transparent"
    implicitWidth: 278
    implicitHeight: 284

    // flutuando: 20px acima da barra e 20px da lateral direita da tela
    anchor.window: barWindow
    anchor.rect.x: barWindow.width - Theme.popupMargin
    anchor.rect.y: -Theme.popupMargin
    anchor.edges: Edges.Top | Edges.Left
    anchor.gravity: Edges.Top | Edges.Left

    // clicar fora fecha
    HyprlandFocusGrab {
        windows: [popup]
        active: popup.visible
        onCleared: popup.visible = false
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bg
        border.color: Theme.fg
        border.width: 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

            // cabeçalho: < Mês Ano >   (clique no título volta para hoje)
            RowLayout {
                Layout.fillWidth: true
                Ctl {
                    text: "\uf053"
                    font.pixelSize: 14
                    onClicked: popup.shift(-1)
                }
                PText {
                    Layout.fillWidth: true
                    text: popup.monthNames[popup.viewMonth] + " " + popup.viewYear
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: popup.goToToday()
                    }
                }
                Ctl {
                    text: "\uf054"
                    font.pixelSize: 14
                    onClicked: popup.shift(1)
                }
            }

            // dias da semana
            Grid {
                columns: 7
                spacing: 2
                Layout.alignment: Qt.AlignHCenter
                Repeater {
                    model: popup.weekdayNames
                    delegate: Item {
                        required property string modelData
                        width: 34
                        height: 20
                        PText {
                            anchors.centerIn: parent
                            text: parent.modelData
                            font.pixelSize: 12
                            opacity: 0.6
                        }
                    }
                }
            }

            // dias do mês (6 semanas)
            Grid {
                columns: 7
                spacing: 2
                Layout.alignment: Qt.AlignHCenter
                Repeater {
                    model: 42
                    delegate: Rectangle {
                        id: cell
                        required property int index

                        readonly property var day: new Date(popup.viewYear, popup.viewMonth, index - popup.firstWeekday + 1)
                        readonly property bool inMonth: day.getMonth() === popup.viewMonth
                        readonly property bool today: day.getFullYear() === clock.date.getFullYear()
                            && day.getMonth() === clock.date.getMonth()
                            && day.getDate() === clock.date.getDate()

                        width: 34
                        height: 30
                        color: today ? Theme.fg : "transparent"

                        PText {
                            anchors.centerIn: parent
                            text: cell.day.getDate()
                            font.pixelSize: 13
                            color: cell.today ? Theme.bg : Theme.fg
                            opacity: cell.inMonth ? 1 : 0.35
                        }
                    }
                }
            }
        }
    }
}
