import Quickshell
import QtQuick
import "bar"

ShellRoot {
    // uma barra por monitor
    Variants {
        model: Quickshell.screens
        Bar {}
    }
}
