import QtQuick

PText {
    id: ctl
    property bool active: true
    signal clicked
    font.pixelSize: 18
    opacity: active ? 1 : 0.4
    MouseArea {
        anchors.fill: parent
        anchors.margins: -6
        onClicked: ctl.clicked()
    }
}
