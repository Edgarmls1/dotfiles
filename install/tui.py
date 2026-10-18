#!/usr/bin/python3
import argparse
import getpass
import os
import shutil
import socket
import subprocess
import tempfile
import tomllib
from pathlib import Path

from textual.app import App, ComposeResult
from textual.binding import Binding
from textual.containers import Horizontal
from textual.widgets import Footer, Header, Label, ListItem, ListView, SelectionList, Static

SCRIPT_DIR = Path(__file__).resolve().parent
DOTFILES_DIR = SCRIPT_DIR.parent
DRY = False


# ======================================================================
#  Execução de comandos
# ======================================================================
def run(cmd, check=True, cwd=None, input=None):
    print("$", " ".join(str(c) for c in cmd))
    if DRY:
        return
    r = subprocess.run(cmd, cwd=cwd, input=input, text=True)
    if r.returncode != 0:
        if check:
            raise SystemExit(f"\nFalhou ({r.returncode}): {' '.join(str(c) for c in cmd)}")
        print(f"  aviso: comando falhou ({r.returncode}), continuando")


def ensure_yay():
    if shutil.which("yay"):
        return
    run(["sudo", "pacman", "-S", "--needed", "--noconfirm", "git", "base-devel"])
    with tempfile.TemporaryDirectory() as tmp:
        run(["git", "clone", "https://aur.archlinux.org/yay.git", f"{tmp}/yay"])
        run(["makepkg", "-si", "--noconfirm"], cwd=f"{tmp}/yay")


# ======================================================================
#  Ações de pós-instalação (referenciadas por nome no packages.toml)
# ======================================================================
def hyprpm_plugins():
    # mantém a exceção do seu script antigo: não instala no mobile-pc
    if socket.gethostname() != "mobile-pc":
        run(["hyprpm", "add", "https://github.com/zjeffer/split-monitor-workspaces"], check=False)
        run(["hyprpm", "enable", "split-monitor-workspaces"], check=False)


def chsh_zsh():
    if os.environ.get("SHELL") != "/bin/zsh":
        run(["chsh", "-s", "/bin/zsh"])


def stow_dotfiles():
    run(["stow", "."], cwd=DOTFILES_DIR)


def orchis_theme():
    with tempfile.TemporaryDirectory() as tmp:
        run(["git", "clone", "https://github.com/vinceliuice/Orchis-theme.git", f"{tmp}/Orchis-theme"])
        run(["./install.sh"], cwd=f"{tmp}/Orchis-theme")
    run(["papirus-folders", "-C", "yaru", "--theme", "Papirus-Dark"], check=False)


def dark_mode():
    path = Path.home() / ".config/xdg-desktop-portal/hyprland-portals.conf"
    print(f"escrevendo {path}")
    if DRY:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("[preferred]\ndefault=hyprland;gtk\n")


def pyenv():
    venv = Path.home() / "pyenv"
    if not venv.is_dir():
        run(["python3", "-m", "venv", str(venv)])


def swap():
    if Path("/swapfile").exists():
        print("/swapfile já existe, pulando")
        return
    gb = input("Quantos GB de swap? ").strip()
    if not gb.isdigit() or int(gb) < 1:
        print("valor inválido, pulando swap")
        return
    run(["sudo", "fallocate", "-l", f"{gb}G", "/swapfile", "-v"])
    run(["sudo", "chmod", "600", "/swapfile"])
    run(["sudo", "mkswap", "/swapfile"])
    run(["sudo", "swapon", "/swapfile"])
    run(["sudo", "tee", "-a", "/etc/fstab"], input="/swapfile none swap defaults 0 0\n")

def minecraft():
    run(["flatpak", "remote-delete", "trinity"])
    run(["flatpak", "remote-add", "trinity", "https://github.com/Trinity-LA/Trinity-Launcher/releases/download/flatpak/com.trench.trinity.launcher.flatpakrepo"])
    run(["flatpak", "install", "com.trench.trinity.launcher"])

ACTIONS = {f.__name__: f for f in (
    hyprpm_plugins, chsh_zsh, stow_dotfiles, orchis_theme, dark_mode, pyenv, swap,
)}


# ======================================================================
#  Leitura do packages.toml
# ======================================================================
LEAF_KEYS = {"packages", "services", "user_groups", "actions", "default"}


def flatten(data: dict) -> dict:
    out = {}
    for cat, groups in data.items():
        out[cat] = {}
        for g, info in groups.items():
            if not info or LEAF_KEYS & info.keys():
                out[cat][g] = info  # grupo normal
            else:  # só tem subgrupos
                for sub, sub_info in info.items():
                    out[cat][f"{g} › {sub}"] = sub_info
    return out


# ======================================================================
#  TUI
# ======================================================================
class Installer(App):
    TITLE = "INSTALL"

    CSS = """
    Screen { background: black; }
    Header { background: black; color: white; text-style: bold; }
    #cats    { width: 28; border-right: solid $primary-darken-2; background: black; }
    #groups  { width: 34; border: none; border-right: solid $primary-darken-2; background: black; }
    #preview { width: 1fr; padding: 0 2; background: black; }
    ListView > ListItem { background: black; }
    ListView > ListItem.--highlight { color: hotpink; text-style: bold; }
    ListView:focus > ListItem.--highlight { background: $accent 30%; color: hotpink; }
    """

    BINDINGS = [
        Binding("right,l", "focus_groups", "Grupos"),
        Binding("left,h", "focus_cats", "Categorias"),
        Binding("i", "install", "Instalar"),
        Binding("q,escape", "quit_app", "Sair"),
    ]

    def __init__(self, data: dict):
        super().__init__()
        self.data = data
        self.cats = list(data)
        self.state = {
            c: {g for g, d in groups.items() if d.get("default")}
            for c, groups in data.items()
        }
        self.current = self.cats[0]
        self.labels: dict[str, Label] = {}

    def compose(self) -> ComposeResult:
        yield Header()
        with Horizontal():
            items = []
            for c in self.cats:
                lbl = Label(self._cat_text(c))
                self.labels[c] = lbl
                items.append(ListItem(lbl, name=c))
            yield ListView(*items, id="cats")
            yield SelectionList[str](id="groups")
            yield Static("", id="preview")
        yield Footer()

    def on_mount(self) -> None:
        self.query_one("#cats", ListView).focus()
        self.load_groups(self.current)

    def _cat_text(self, cat: str) -> str:
        n = len(self.state[cat])
        return f"{cat} [{n}]" if n else cat

    def load_groups(self, cat: str) -> None:
        sl = self.query_one("#groups", SelectionList)
        sl.clear_options()
        sl.add_options([(g, g, g in self.state[cat]) for g in self.data[cat]])
        self.show_group(cat, next(iter(self.data[cat]), None))

    def show_group(self, cat: str, group: str | None) -> None:
        preview = self.query_one("#preview", Static)
        if group is None:
            preview.update("")
            return
        info = self.data[cat][group]
        lines = [f"[hotpink]{group}[/]", ""]
        lines += [f"- {p}" for p in info.get("packages", [])]
        extra = []
        if info.get("services"):
            extra.append("enable: " + ", ".join(info["services"]))
        if info.get("user_groups"):
            extra.append("usermod -aG " + ",".join(info["user_groups"]))
        extra += [f"run: {a}" for a in info.get("actions", [])]
        if extra:
            lines += [""] + [f"[dim]+ {e}[/]" for e in extra]
        preview.update("\n".join(lines))

    def on_list_view_highlighted(self, event: ListView.Highlighted) -> None:
        if event.item is None or event.item.name == self.current:
            return
        self.current = event.item.name
        self.load_groups(self.current)

    def on_selection_list_selection_highlighted(self, event: SelectionList.SelectionHighlighted) -> None:
        self.show_group(self.current, event.selection.value)

    def on_selection_list_selection_toggled(self, event: SelectionList.SelectionToggled) -> None:
        self.state[self.current] = set(event.selection_list.selected)
        self.labels[self.current].update(self._cat_text(self.current))

    def action_focus_groups(self) -> None:
        self.query_one("#groups").focus()

    def action_focus_cats(self) -> None:
        self.query_one("#cats").focus()

    def action_install(self) -> None:
        # mantém a ordem do arquivo
        chosen = [(c, g) for c in self.cats for g in self.data[c] if g in self.state[c]]
        self.exit(chosen)

    def action_quit_app(self) -> None:
        self.exit(None)


# ======================================================================
#  main
# ======================================================================
def main() -> None:
    global DRY
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", default=SCRIPT_DIR / "packages.toml")
    ap.add_argument("--dry-run", action="store_true", help="só mostra os comandos")
    args = ap.parse_args()
    DRY = args.dry_run

    with open(args.config, "rb") as f:
        data = flatten(tomllib.load(f))

    chosen = Installer(data).run()
    if not chosen:
        print("Cancelado.")
        return

    infos = [(f"{c} / {g}", data[c][g]) for c, g in chosen]
    packages = list(dict.fromkeys(p for _, i in infos for p in i.get("packages", [])))

    print("\nResumo:")
    for name, i in infos:
        print(f"  - {name}")
    print(f"\n{len(packages)} pacotes: {' '.join(packages)}")

    if input("\nContinuar? [s/N] ").strip().lower() not in ("s", "y"):
        print("Cancelado.")
        return

    if packages:
        ensure_yay()
        run(["yay", "-S", "--needed", "--noconfirm", *packages])

    for name, i in infos:
        print(f"\n== {name} ==")
        for svc in i.get("services", []):
            run(["sudo", "systemctl", "enable", svc], check=False)
        if i.get("user_groups"):
            run(["sudo", "usermod", "-aG", ",".join(i["user_groups"]), getpass.getuser()])
        for a in i.get("actions", []):
            ACTIONS[a]()


if __name__ == "__main__":
    main()
