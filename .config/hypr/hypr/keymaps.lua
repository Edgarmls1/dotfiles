-------------------
--- MY PROGRAMS ---
-------------------

local terminal    = "kitty"
local tuiFileMgr  = "kitty ranger"
local guiFileMgr  = "dolphin"

-------------------
--- KEYBINDINGS ---
-------------------

local super = "SUPER"

local exec = hl.dsp.exec_cmd

local overview = hl.plugin.gloview
local smw = hl.plugin.split_monitor_workspaces

hl.bind(super .. " + Q",         exec(terminal))
hl.bind(super .. " + E",         exec(tuiFileMgr))
hl.bind(super .. " + SHIFT + E", exec(guiFileMgr))
hl.bind(super .. " + SPACE",     exec(os.getenv("HOME") .. "/dotfiles/scripts/bemenu"))

hl.bind(super .. " + SHIFT + PERIOD", exec(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh next"))
hl.bind(super .. " + SHIFT + COMMA",  exec(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh prev"))

hl.bind(super .. " + M",        exec(os.getenv("HOME") .. "/dotfiles/scripts/monitors.sh"))

hl.bind(super .. " + SHIFT + S", exec("killall hyprsunset || hyprsunset"))
hl.bind(super .. " + W",         exec("killall waybar || waybar"))
hl.bind(super .. " + Escape",    exec("wleave"))
hl.bind(super .. " + L",         exec("hyprlock"))

hl.bind(super .. " + O", overview.toggle)

hl.bind("Print",         exec("hyprshot -m region -m active -o ~/Pictures/Screenshots/"))
hl.bind("SHIFT + Print", exec("hyprshot -m region -m output -o ~/Pictures/Screenshots/"))

local closeWindowBind = hl.bind(super .. " + C",         hl.dsp.window.close())
hl.bind(super .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(super .. " + S",         hl.dsp.layout("togglesplit"))
hl.bind(super .. " + F",         hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(super .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

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
    hl.bind(super .. " + " .. key,         function() return smw.workspace(i) end)
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
