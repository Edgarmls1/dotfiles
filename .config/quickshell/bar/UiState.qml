pragma Singleton
import Quickshell
import QtQuick

// estado de UI compartilhado entre módulos
Singleton {
    property bool showDate: false

    // elemento único CPU/MEM: "cpu" ou "mem" (clique esquerdo alterna)
    property string resMode: "cpu"
}
