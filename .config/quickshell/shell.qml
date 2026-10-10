import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Bluetooth
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    // ---------- tema ----------
    readonly property color fg: "#ffffff"
    readonly property color bg: "#000000"
    readonly property string fontFamily: "Hack Nerd Font"
    readonly property string term: "wezterm"

    // ---------- estado global ----------
    property int cpu: 0
    property int memPct: 0
    property string netState: "none"
    property bool showDate: false
    property var wallpapers: []

    // elemento único CPU/MEM: "cpu" ou "mem" (clique esquerdo alterna)
    property string resMode: "cpu"
    property var topProcs: []
    onResModeChanged: topProcs = []

    readonly property int popupMargin: 20

    readonly property string wallDir: Quickshell.env("HOME") + "/dotfiles/wallpapers"
    readonly property string wallConf: Quickshell.env("HOME") + "/.config/hypr/hyprpaper.conf"

    readonly property var player: {
        const ps = Array.from(Mpris.players.values);
        return ps.find(p => p.dbusName.toLowerCase().includes("spotify")) ?? null;
    }

    function fmt(sec) {
        const s = Math.max(0, Math.floor(sec));
        return Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0");
    }

    // ---------- componentes de texto ----------
    component BarText: Text {
        color: "#ffffff"
        font.family: "Hack Nerd Font"
        font.pixelSize: 14
        font.weight: Font.Bold
        verticalAlignment: Text.AlignVCenter
        padding: 2
        Layout.fillHeight: true
    }

    component PText: Text {
        color: "#ffffff"
        font.family: "Hack Nerd Font"
        font.pixelSize: 13
        font.weight: Font.Bold
    }

    // botão de controle do player (glifo + clique)
    component Ctl: PText {
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

    // ---------- fontes de dados ----------
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // emitido quando o volume/mute muda por qualquer meio (teclas, pavucontrol, scroll...)
    signal volumeTouched
    property bool volReady: false
    Timer {
        running: true
        interval: 2000
        onTriggered: root.volReady = true   // ignora as mudanças iniciais ao carregar
    }
    Connections {
        target: Pipewire.defaultAudioSink?.audio ?? null
        function onVolumeChanged() { if (root.volReady) root.volumeTouched(); }
        function onMutedChanged() { if (root.volReady) root.volumeTouched(); }
    }

    // CPU% e MEM% a cada 1s, um processo só
    Process {
        running: true
        command: ["bash", "-c", `
            pt=0; pi=0
            while true; do
                read -r _ u n s i w irq sirq st _ < /proc/stat
                idle=$((i+w)); total=$((u+n+s+i+w+irq+sirq+st))
                dt=$((total-pt)); di=$((idle-pi))
                if [ $dt -gt 0 ]; then cpu=$(( 100*(dt-di)/dt )); else cpu=0; fi
                pt=$total; pi=$idle
                mem=$(awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf "%d", (t-a)*100/t}' /proc/meminfo)
                echo "$cpu $mem"
                sleep 1
            done
        `]
        stdout: SplitParser {
            onRead: line => {
                const p = line.trim().split(" ");
                root.cpu = parseInt(p[0]);
                root.memPct = parseInt(p[1]);
            }
        }
    }

    // rede: cabo / wifi / nada (interfaces físicas com operstate=up)
    Process {
        id: netProc
        command: ["sh", "-c", `
            w=0; e=0
            for d in /sys/class/net/*; do
                [ -e "$d/device" ] || continue
                [ "$(cat "$d/operstate" 2>/dev/null)" = up ] || continue
                if [ -d "$d/wireless" ]; then w=1; else e=1; fi
            done
            if [ $e = 1 ]; then echo wired; elif [ $w = 1 ]; then echo wifi; else echo none; fi
        `]
        stdout: StdioCollector {
            onStreamFinished: root.netState = this.text.trim()
        }
    }
    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: netProc.running = true
    }

    // top 5 processos por CPU ou MEM (rodado enquanto o popup está aberto)
    // CPU usa o 2º quadro do top (uso instantâneo); MEM usa o 1º.
    Process {
        id: topProc
        command: ["sh", "-c",
            `LC_ALL=C top -b -n "$1" -d 1 -o "$2" | awk -v F="$1" '/^top -/{f++} f==F && $1 ~ /^[0-9]+$/ { c=""; for(i=12;i<=NF;i++) c=c (i>12?" ":"") $i; print $1, $9, $10, c; n++ } n==5{exit}'`,
            "_",
            root.resMode === "cpu" ? "2" : "1",
            root.resMode === "cpu" ? "%CPU" : "%MEM"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.topProcs = this.text.trim().split("\n")
                    .map(l => l.split(" "))
                    .filter(p => p.length >= 4)
                    .map(p => ({
                        pid: p[0],
                        cpu: p[1].replace(",", "."),
                        mem: p[2].replace(",", "."),
                        name: p.slice(3).join(" ")
                    }));
            }
        }
    }

    // lista de wallpapers (atualizada toda vez que o popup abre)
    Process {
        id: wallProc
        command: ["sh", "-c",
            `find -L "$1" -type f | grep -iE '[.](jpe?g|png|webp|bmp)$' | sort`,
            "_", root.wallDir]
        stdout: StdioCollector {
            onStreamFinished: root.wallpapers = this.text.trim().split("\n").filter(l => l.length > 0)
        }
    }

    // ---------- barra (uma por monitor) ----------
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData

            // monitor do Hyprland correspondente a esta barra
            readonly property var monitor: Hyprland.monitorFor(modelData)

            // grupo expansível (tray, rede, bluetooth, cpu/mem, música, wallpaper)
            property bool expanded: false
            onExpandedChanged: {
                if (!expanded) {
                    mediaPopup.visible = false;
                    wallPopup.visible = false;
                    resPopup.visible = false;
                }
            }

            anchors {
                bottom: true
                left: true
                right: true
            }
            implicitHeight: 24
            color: root.bg

            // ===== ESQUERDA: workspaces =====
            RowLayout {
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                spacing: 0

                Repeater {
                    model: Array.from(Hyprland.workspaces.values)
                        .filter(w => w.id > 0 && w.monitor === bar.monitor)
                        .sort((a, b) => a.id - b.id)

                    delegate: Rectangle {
                        id: ws
                        required property var modelData

                        // workspace ativo DESTE monitor (não o global)
                        readonly property bool active: bar.monitor?.activeWorkspace === modelData
                        readonly property bool empty: modelData.toplevels.values.length === 0

                        Layout.fillHeight: true
                        implicitWidth: label.implicitWidth + 12
                        color: (active || empty) ? root.fg : "transparent"
                        opacity: empty ? 0.5 : 1

                        Text {
                            id: label
                            anchors.centerIn: parent
                            // 1-9 e 11-19 -> 一..九 (10 -> 十)
                            text: "一二三四五六七八九十"[(ws.modelData.id - 1) % 10]
                            color: (ws.active || ws.empty) ? root.bg : root.fg
                            font.family: root.fontFamily
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

            // ===== DIREITA: módulos =====
            RowLayout {
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                spacing: 0

                // ===== GRUPO EXPANSÍVEL =====
                // expande para a esquerda do botão [<] / [>]
                Item {
                    id: group
                    Layout.fillHeight: true
                    clip: true
                    implicitWidth: bar.expanded ? groupRow.implicitWidth : 0
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

                        // [ tray ]
                        BarText { text: "[" }
                        Repeater {
                            model: SystemTray.items
                            delegate: MouseArea {
                                id: trayItem
                                required property var modelData
                                Layout.preferredWidth: 18
                                Layout.preferredHeight: 18
                                Layout.alignment: Qt.AlignVCenter
                                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                                onClicked: ev => {
                                    if (ev.button === Qt.LeftButton) {
                                        if (modelData.onlyMenu && modelData.hasMenu) menu.open();
                                        else modelData.activate();
                                    } else if (ev.button === Qt.MiddleButton) {
                                        modelData.secondaryActivate();
                                    } else if (modelData.hasMenu) {
                                        menu.open();
                                    }
                                }

                                IconImage {
                                    anchors.fill: parent
                                    source: trayItem.modelData.icon
                                }

                                QsMenuAnchor {
                                    id: menu
                                    menu: trayItem.modelData.menu
                                    anchor.item: trayItem
                                    anchor.edges: Edges.Top
                                    anchor.gravity: Edges.Top
                                }
                            }
                        }
                        BarText { text: "]" }

                        // network
                        BarText {
                            text: root.netState === "wired" ? "[WIRED]"
                                : root.netState === "wifi" ? "[WIFI]"
                                : "[NO LAN]"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: Quickshell.execDetached([root.term, "-e", "gazelle"])
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
                                onClicked: Quickshell.execDetached([root.term, "-e", "bluetui"])
                            }
                        }

                        // cpu / mem (elemento único)
                        // clique esquerdo: alterna CPU <-> MEM
                        // clique direito: popup com os 5 processos que mais consomem
                        BarText {
                            id: resBtn
                            text: root.resMode === "cpu"
                                ? `[CPU ${root.cpu}%]`
                                : `[MEM ${root.memPct}%]`
                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                onClicked: ev => {
                                    if (ev.button === Qt.RightButton)
                                        resPopup.visible = !resPopup.visible;
                                    else
                                        root.resMode = root.resMode === "cpu" ? "mem" : "cpu";
                                }
                            }
                        }

                        // NOVO: media (no lugar do power-profiles)
                        BarText {
                            id: mediaBtn
                            text: "[MUS]"
                            opacity: root.player ? 1 : 0.5
                            MouseArea {
                                anchors.fill: parent
                                onClicked: mediaPopup.visible = !mediaPopup.visible
                            }
                        }

                        // NOVO: seletor de wallpaper
                        BarText {
                            id: wallBtn
                            text: "[WALL]"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: wallPopup.visible = !wallPopup.visible
                            }
                        }

                    }
                }

                // botão que expande/recolhe o grupo
                BarText {
                    text: bar.expanded ? "[>]" : "[<]"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: bar.expanded = !bar.expanded
                    }
                }

                // pulseaudio
                BarText {
                    id: vol
                    readonly property var audio: Pipewire.defaultAudioSink?.audio ?? null
                    text: !audio ? "[VOL --]"
                        : audio.muted ? "[MUTED]"
                        : `[VOL ${Math.round(audio.volume * 100)}%]`

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: ev => {
                            if (ev.button === Qt.RightButton) {
                                if (vol.audio) vol.audio.muted = !vol.audio.muted;
                            } else if (volPopup.visible && volPopup.manual) {
                                volPopup.visible = false;
                            } else {
                                volPopup.manual = true;
                                volPopup.visible = true;
                            }
                        }
                        onWheel: w => {
                            if (!vol.audio) return;
                            const step = w.angleDelta.y > 0 ? 0.05 : -0.05;
                            vol.audio.volume = Math.max(0, Math.min(1.0, vol.audio.volume + step));
                        }
                    }
                }

                // clock (clique alterna hora / data)
                BarText {
                    text: root.showDate
                        ? `[${Qt.formatDateTime(clock.date, "dd|MM|yy")}]`
                        : `[${Qt.formatDateTime(clock.date, "HH:mm")}]`
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.showDate = !root.showDate
                    }
                }
            }

            // ===== POPUP: Volume =====
            // manual (clique esquerdo): fica aberto até clicar fora.
            // automático (volume mudou por outro meio): some sozinho após 2s.
            PopupWindow {
                id: volPopup
                visible: false
                property bool manual: false
                color: "transparent"
                implicitWidth: 300
                implicitHeight: 92

                // flutuando: 20px acima da barra e 20px da lateral direita da tela
                anchor.window: bar
                anchor.rect.x: bar.width - root.popupMargin
                anchor.rect.y: -root.popupMargin
                anchor.edges: Edges.Top | Edges.Left
                anchor.gravity: Edges.Top | Edges.Left

                onVisibleChanged: if (!visible) manual = false

                // só rouba o foco quando aberto manualmente
                HyprlandFocusGrab {
                    windows: [volPopup]
                    active: volPopup.visible && volPopup.manual
                    onCleared: volPopup.visible = false
                }

                Timer {
                    id: volHide
                    interval: 2000
                    onTriggered: if (!volPopup.manual && !volHover.hovered) volPopup.visible = false
                }

                // mostra no monitor em foco quando o volume mudar
                Connections {
                    target: root
                    function onVolumeTouched() {
                        if (bar.monitor !== Hyprland.focusedMonitor) return;
                        volPopup.visible = true;
                        if (!volPopup.manual) volHide.restart();
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: root.bg
                    border.color: root.fg
                    border.width: 2

                    HoverHandler {
                        id: volHover
                        onHoveredChanged: if (!hovered && !volPopup.manual) volHide.restart()
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 10

                        RowLayout {
                            spacing: 10
                            PText {
                                text: vol.audio?.muted ? "\uf026" : "\uf028"
                                font.pixelSize: 16
                            }
                            PText {
                                text: "Volume"
                                font.pixelSize: 14
                            }
                            Item { Layout.fillWidth: true }
                            PText {
                                text: vol.audio
                                    ? (vol.audio.muted ? "MUTED" : Math.round(vol.audio.volume * 100) + "%")
                                    : "--"
                                font.pixelSize: 14
                            }
                        }

                        // barra de 0 a 100 (clique ou arraste; scroll ajusta)
                        Item {
                            id: slider
                            Layout.fillWidth: true
                            Layout.preferredHeight: 24

                            function setFromX(x) {
                                if (vol.audio)
                                    vol.audio.volume = Math.max(0, Math.min(1, x / width));
                            }

                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                height: 6
                                color: "#444444"

                                Rectangle {
                                    height: parent.height
                                    color: root.fg
                                    opacity: vol.audio?.muted ? 0.4 : 1
                                    width: vol.audio
                                        ? parent.width * Math.max(0, Math.min(1, vol.audio.volume))
                                        : 0
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                preventStealing: true
                                onPressed: m => slider.setFromX(m.x)
                                onPositionChanged: m => { if (pressed) slider.setFromX(m.x); }
                                onWheel: w => {
                                    if (!vol.audio) return;
                                    const step = w.angleDelta.y > 0 ? 0.05 : -0.05;
                                    vol.audio.volume = Math.max(0, Math.min(1, vol.audio.volume + step));
                                }
                            }
                        }
                    }
                }
            }

            // ===== POPUP: Top 5 processos (CPU / MEM) =====
            PopupWindow {
                id: resPopup
                visible: false
                color: "transparent"
                implicitWidth: 360
                implicitHeight: 210

                // flutuando: 20px acima da barra e 20px da lateral direita da tela
                anchor.window: bar
                anchor.rect.x: bar.width - root.popupMargin
                anchor.rect.y: -root.popupMargin
                anchor.edges: Edges.Top | Edges.Left
                anchor.gravity: Edges.Top | Edges.Left

                HyprlandFocusGrab {
                    windows: [resPopup]
                    active: resPopup.visible
                    onCleared: resPopup.visible = false
                }

                // atualiza a lista a cada 2s enquanto estiver aberto
                Timer {
                    running: resPopup.visible
                    interval: 2000
                    repeat: true
                    triggeredOnStart: true
                    onTriggered: topProc.running = true
                }

                Rectangle {
                    anchors.fill: parent
                    color: root.bg
                    border.color: root.fg
                    border.width: 2

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 10

                        RowLayout {
                            spacing: 10
                            Ctl {
                                text: "\uf053"
                                font.pixelSize: 14
                                onClicked: resPopup.visible = false
                            }
                            PText {
                                text: "Top 5 - " + (root.resMode === "cpu" ? "CPU" : "MEM")
                                font.pixelSize: 14
                            }
                        }

                        PText {
                            visible: root.topProcs.length === 0
                            text: "..."
                            opacity: 0.5
                        }

                        Repeater {
                            model: root.topProcs

                            delegate: RowLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                spacing: 10

                                PText {
                                    text: modelData.pid
                                    opacity: 0.5
                                    Layout.preferredWidth: 56
                                }
                                PText {
                                    text: modelData.name
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                                PText {
                                    text: (root.resMode === "cpu" ? modelData.cpu : modelData.mem) + "%"
                                    Layout.preferredWidth: 60
                                    horizontalAlignment: Text.AlignRight
                                }
                            }
                        }

                        Item { Layout.fillHeight: true }
                    }
                }
            }

            // ===== POPUP: Wallpapers =====
            PopupWindow {
                id: wallPopup
                visible: false
                color: "transparent"
                implicitWidth: 540
                implicitHeight: 380

                // flutuando: 20px acima da barra e 20px da lateral direita da tela
                anchor.window: bar
                anchor.rect.x: bar.width - root.popupMargin
                anchor.rect.y: -root.popupMargin
                anchor.edges: Edges.Top | Edges.Left
                anchor.gravity: Edges.Top | Edges.Left

                onVisibleChanged: if (visible) wallProc.running = true

                HyprlandFocusGrab {
                    windows: [wallPopup]
                    active: wallPopup.visible
                    onCleared: wallPopup.visible = false
                }

                Rectangle {
                    anchors.fill: parent
                    color: root.bg
                    border.color: root.fg
                    border.width: 2

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 10

                        RowLayout {
                            spacing: 10
                            Ctl {
                                text: "\uf053"
                                font.pixelSize: 14
                                onClicked: wallPopup.visible = false
                            }
                            PText {
                                text: "Wallpapers (" + root.wallpapers.length + ")"
                                font.pixelSize: 14
                            }
                        }

                        GridView {
                            id: grid
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            cellWidth: 168
                            cellHeight: 100
                            model: root.wallpapers

                            delegate: Item {
                                id: cell
                                required property string modelData
                                width: grid.cellWidth
                                height: grid.cellHeight

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.margins: 4
                                    color: "#222222"
                                    border.color: root.fg
                                    border.width: hover.containsMouse ? 2 : 0

                                    Image {
                                        anchors.fill: parent
                                        anchors.margins: 2
                                        source: "file://" + cell.modelData
                                        sourceSize.width: 320
                                        sourceSize.height: 180
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                    }

                                    MouseArea {
                                        id: hover
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: Quickshell.execDetached(["sh", "-c",
                                            `paper=$(realpath --relative-to="$2" "$1")
                                            sed -i -E "s|wallpapers/.*|wallpapers/$paper|g" "$3"
                                            pkill hyprpaper
                                            setsid hyprpaper >/dev/null 2>&1 &`,
                                            "_", cell.modelData, root.wallDir, root.wallConf])
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ===== POPUP: Media Player =====
            PopupWindow {
                id: mediaPopup
                visible: false
                color: "transparent"
                implicitWidth: 230
                implicitHeight: 400

                // flutuando: 20px acima da barra e 20px da lateral direita da tela
                anchor.window: bar
                anchor.rect.x: bar.width - root.popupMargin
                anchor.rect.y: -root.popupMargin
                anchor.edges: Edges.Top | Edges.Left
                anchor.gravity: Edges.Top | Edges.Left

                // clicar fora fecha
                HyprlandFocusGrab {
                    windows: [mediaPopup]
                    active: mediaPopup.visible
                    onCleared: mediaPopup.visible = false
                }

                // a posição só atualiza se mandarmos o sinal
                Timer {
                    running: mediaPopup.visible && (root.player?.isPlaying ?? false)
                    interval: 500
                    repeat: true
                    onTriggered: root.player?.positionChanged()
                }

                Rectangle {
                    anchors.fill: parent
                    color: root.bg
                    border.color: root.fg
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
                                onClicked: mediaPopup.visible = false
                            }
                            PText {
                                text: "Media Player"
                                font.pixelSize: 14
                            }
                        }

                        // capa + título/artista
                        RowLayout {
                            spacing: 14

                            Rectangle {
                                Layout.preferredWidth: 200
                                Layout.preferredHeight: 200
                                Layout.alignment: Qt.AlignHCenter
                                color: "transparent"
                                border.color: root.fg
                                border.width: 2

                                Image {
                                    id: art
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    source: root.player?.trackArtUrl ?? ""
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
                                text: root.player?.trackTitle || "Nothing playing"
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
                                text: root.player?.trackArtist ?? ""
                                opacity: 0.7
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight
                            }
                        }
                        

                        // barra de progresso
                        RowLayout {
                            spacing: 8
                            PText {
                                text: root.fmt(root.player?.position ?? 0)
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
                                        color: root.fg
                                        width: (root.player && root.player.length > 0)
                                            ? parent.width * Math.min(1, root.player.position / root.player.length)
                                            : 0
                                    }
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: m => {
                                        const p = root.player;
                                        if (p && p.canSeek && p.length > 0)
                                            p.position = Math.max(0, Math.min(1, m.x / width)) * p.length;
                                    }
                                }
                            }
                            PText {
                                text: "-" + root.fmt((root.player?.length ?? 0) - (root.player?.position ?? 0))
                                font.pixelSize: 11
                            }
                        }

                        // controles
                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 26

                            Ctl {
                                text: "\uf048"
                                active: root.player?.canGoPrevious ?? false
                                onClicked: root.player?.previous()
                            }
                            Ctl {
                                text: root.player?.isPlaying ? "\uf04c" : "\uf04b"
                                font.pixelSize: 22
                                active: root.player?.canTogglePlaying ?? false
                                onClicked: root.player?.togglePlaying()
                            }
                            Ctl {
                                text: "\uf051"
                                active: root.player?.canGoNext ?? false
                                onClicked: root.player?.next()
                            }
                        }
                    }
                }
            }
        }
    }
}
