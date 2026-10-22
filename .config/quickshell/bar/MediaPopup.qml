import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PopupWindow {
    id: popup

    required property var barWindow

    visible: false
    color: "transparent"
    implicitWidth: 230
    implicitHeight: 400

    anchor.window: barWindow
    anchor.rect.x: barWindow.width - Theme.popupMargin
    anchor.rect.y: -Theme.popupMargin
    anchor.edges: Edges.Top | Edges.Left
    anchor.gravity: Edges.Top | Edges.Left

    HyprlandFocusGrab {
        windows: [popup]
        active: popup.visible
        onCleared: popup.visible = false
    }

    Timer {
        running: popup.visible && (Media.player?.isPlaying ?? false)
        interval: 500
        repeat: true
        onTriggered: Media.player?.positionChanged()
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bg
        border.color: Theme.fg
        border.width: 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12

            // cabeçalho
            RowLayout {
                spacing: 10
                Ctl {
                    text: "\uf053"
                    font.pixelSize: 14
                    onClicked: popup.visible = false
                }
                PText {
                    text: "Media Player"
                    font.pixelSize: 14
                }
            }

            RowLayout {
                spacing: 14

                Rectangle {
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 200
                    Layout.alignment: Qt.AlignHCenter
                    color: "transparent"
                    border.color: Theme.fg
                    border.width: 2

                    Image {
                        id: art
                        anchors.fill: parent
                        anchors.margins: 2
                        source: Media.player?.trackArtUrl ?? ""
                        fillMode: Image.PreserveAspectCrop
                        visible: status === Image.Ready
                    }
                    PText {
                        anchors.centerIn: parent
                        visible: !art.visible
                        text: "\uf001"
                        font.pixelSize: 36
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 4
                PText {
                    Layout.fillWidth: true
                    text: Media.player?.trackTitle || "Nothing playing"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 4
                PText {
                    Layout.fillWidth: true
                    text: Media.player?.trackArtist ?? ""
                    opacity: 0.7
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                }
            }

            RowLayout {
                spacing: 8
                PText {
                    text: Media.fmt(Media.player?.position ?? 0)
                    font.pixelSize: 11
                }
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 16

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        height: 4
                        color: "#444444"

                        Rectangle {
                            height: parent.height
                            color: Theme.fg
                            width: (Media.player && Media.player.length > 0)
                                ? parent.width * Math.min(1, Media.player.position / Media.player.length)
                                : 0
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: m => {
                            const p = Media.player;
                            if (p && p.canSeek && p.length > 0)
                                p.position = Math.max(0, Math.min(1, m.x / width)) * p.length;
                        }
                    }
                }
                PText {
                    text: "-" + Media.fmt((Media.player?.length ?? 0) - (Media.player?.position ?? 0))
                    font.pixelSize: 11
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 26

                Ctl {
                    text: "\uf048"
                    active: Media.player?.canGoPrevious ?? false
                    onClicked: Media.player?.previous()
                }
                Ctl {
                    text: Media.player?.isPlaying ? "\uf04c" : "\uf04b"
                    font.pixelSize: 22
                    active: Media.player?.canTogglePlaying ?? false
                    onClicked: Media.player?.togglePlaying()
                }
                Ctl {
                    text: "\uf051"
                    active: Media.player?.canGoNext ?? false
                    onClicked: Media.player?.next()
                }
            }
        }
    }
}
