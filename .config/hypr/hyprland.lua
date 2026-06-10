---------------------------------------------------------
---------------------------------------------------------
--  _   ___   ______  ____  _        _    _   _ ____   --
-- | | | \ \ / /  _ \|  _ \| |      / \  | \ | |  _ \  --
-- | |_| |\ V /| |_) | |_) | |     / _ \ |  \| | | | | --
-- |  _  | | | |  __/|  _ <| |___ / ___ \| |\  | |_| | --
-- |_| |_| |_| |_|   |_| \_\_____/_/   \_\_| \_|____/  --
---------------------------------------------------------
---------------------------------------------------------

----------------
--- MONITORS ---
----------------

hl.monitor({
	output   = "eDP-1",
	mode     = "1920x1080",
	position = "0x0",
	scale    = "1",
})

hl.monitor({
	output   = "HDMI-A-2",
	mode     = "1920x1080",
	position = "1921x0",
	scale    = "1",
})

hl.monitor({
	output   = "DP-1",
	mode     = "1920x1080",
	position = "1921x1081",
	scale    = "1",
})

-- mobile pc
-- hl.monitor({
--     output   = "",
--     mode     = "1920x1080",
--     position = "0x0",
--     scale    = "1",
-- })

-------------------
--- MY PROGRAMS ---
-------------------

local terminal    = "kitty"
local tuiFileMgr  = "kitty yazi"
local guiFileMgr  = "nemo"
local menu        = "anyrun"
local browser     = "zen-browser"
local nerdBrowser = "qutebrowser"
local music       = "spotify"

-----------------
--- AUTOSTART ---
-----------------

hl.on("hyprland.start", function ()
	hl.exec_cmd("waybar")
	hl.exec_cmd("dunst")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("spotify-tray-wayland")
	hl.exec_cmd(os.getenv("HOME") .. "/dotfiles/scripts/monitors.sh")
	hl.exec_cmd(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh")

    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-Dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Classic")
end)

-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_QPA_PLATFORM",      "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-----------------------
----- PERMISSIONS -----
-----------------------

hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")

---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
	general = {
		gaps_in  = 0,
		gaps_out = 0,

		border_size = 2,

		col = {
			active_border   = "rgba(ffffffff)",
			inactive_border = "rgba(595959aa)",
		},

		resize_on_border = false,

		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 0,

		active_opacity   = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled      = false,
			range        = 4,
			render_power = 3,
			color        = 0x1a1a1aee,
		},

		blur = {
			enabled        = true,
			size           = 8,
			passes         = 2,
			vibrancy       = 0.1696,
			ignore_opacity = true,
		},
	},

	animations = {
		enabled = false,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo   = true,
	},
})

-- hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

-- hl.animation({ leaf = "border",     enabled = true, speed = 10,  bezier = "default" })
-- hl.animation({ leaf = "windows",    enabled = true, speed = 7,   bezier = "myBezier" })
-- hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,   bezier = "default", style = "popin 80%" })
-- hl.animation({ leaf = "fade",       enabled = true, speed = 7,   bezier = "default" })
-- hl.animation({ leaf = "workspaces", enabled = true, speed = 6,   bezier = "default" })

-------------
--- INPUT ---
-------------

hl.config({
	input = {
		kb_layout  = "br",
		kb_variant = "abnt2",
		kb_model   = "",
		kb_options = "",
		kb_rules   = "",

		follow_mouse = 1,

		sensitivity = 0,

		touchpad = {
			natural_scroll = true,
		},
	},
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.device({
	name        = "epic-mouse-v1",
	sensitivity = -0.5,
})

---------------
--- PLUGINS ---
---------------

hl.config({
    plugin = {
        split_monitor_workspaces = {
            count                        = 10,
            keep_focused                 = 0,
            enable_notifications         = 0,
            enable_persistent_workspaces = 0,
            enable_wrapping              = 1,
            link_monitors                = 0,
            -- enable_hy3                = 1,
        },
    },
})

local smw = hl.plugin.split_monitor_workspaces
smw.monitor_priority({ "HDMI-A-2", "DP-1", "eDP-1" })

smw.max_workspaces({ monitor = "eDP-1",    max = 10 })
smw.max_workspaces({ monitor = "HDMI-A-2", max = 10 })
smw.max_workspaces({ monitor = "DP-1",     max = 10 })

-------------------
--- KEYBINDINGS ---
-------------------

local super = "SUPER"

local exec = hl.dsp.exec_cmd

hl.bind(super .. " + Q",         exec(terminal))
hl.bind(super .. " + E",         exec(tuiFileMgr))
hl.bind(super .. " + SHIFT + E", exec(guiFileMgr))
hl.bind(super .. " + SPACE",     exec(menu))
hl.bind(super .. " + B",         exec(browser))
hl.bind(super .. " + SHIFT + B", exec(nerdBrowser))
hl.bind(super .. " + S",         exec(music))

hl.bind("CTRL + right", exec(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh next"))
hl.bind("CTRL + left",  exec(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh prev"))

hl.bind(super .. " + M", exec(os.getenv("HOME") .. "/dotfiles/scripts/monitors.sh"))

hl.bind(super .. " + Escape", exec("killall waybar || waybar"))
hl.bind(super .. " + W",   exec("wleave"))
hl.bind(super .. " + L",   exec("hyprlock"))

hl.bind("Print",         exec("hyprshot -m region -m active -o ~/Pictures/"))
hl.bind("SHIFT + Print", exec("hyprshot -m region -m output -o ~/Pictures/"))

local closeWindowBind = hl.bind(super .. " + C",         hl.dsp.window.close())
hl.bind(super .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(super .. " + F",         hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(super .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(super .. " + SHIFT + S", hl.dsp.layout("togglesplit"))

hl.bind(super .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(super .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(super .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(super .. " + down",  hl.dsp.focus({ direction = "down" }))

hl.bind(super .. " + SHIFT + left", function() hl.dispatch(hl.dsp.window.resize({ x = -10, y = 0, relative = true })) end)
hl.bind(super .. " + SHIFT + right", function() hl.dispatch(hl.dsp.window.resize({ x = 10, y = 0, relative = true })) end)
hl.bind(super .. " + SHIFT + up", function() hl.dispatch(hl.dsp.window.resize({ x = -0, y = -10, relative = true })) end)
hl.bind(super .. " + SHIFT + down", function() hl.dispatch(hl.dsp.window.resize({ x = -0, y = 10, relative = true })) end)

hl.bind(super .. " + CTRL + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind(super .. " + CTRL + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(super .. " + CTRL + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind(super .. " + CTRL + down",  hl.dsp.window.swap({ direction = "down" }))

for i = 1, 9 do
    local key = tostring(i)
    hl.bind(super .. " + " .. key, function() return smw.workspace(i) end)
    hl.bind(super .. " + SHIFT + " .. key, function() return smw.move_to_workspace(i) end)
end

-- mobile pc
-- for i = 1, 10 do
--     local key = i % 10
--     hl.bind(super .. " + " .. key,             hl.dsp.focus({ workspace = i}))
--     hl.bind(super .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
-- end

hl.bind(super .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(super .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && notify-send \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@)\""), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@)\""), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@)\""), { locked = true })
hl.bind("XF86AudioMicMute",     exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

hl.bind("XF86MonBrightnessUp",   exec("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", exec("brightnessctl s 10%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext",  exec(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh next"), { locked = true })
hl.bind("XF86AudioPause", exec(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh play"), { locked = true })
hl.bind("XF86AudioPlay",  exec(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh play"), { locked = true })
hl.bind("XF86AudioPrev",  exec(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh prev"), { locked = true })
