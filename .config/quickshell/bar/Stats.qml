pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// CPU%, MEM% e estado da rede
Singleton {
    id: root

    property int cpu: 0
    property int memPct: 0
    property string netState: "none"

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
}
