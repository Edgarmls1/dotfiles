-------------------
--- MY PROGRAMS ---
-------------------

local terminal    = "wezterm"
local tuiFileMgr  = "wezterm -e yazi"
local guiFileMgr  = "nautilus"

-------------------
--- KEYBINDINGS ---
-------------------

local super = "SUPER"
local exec  = hl.dsp.exec_cmd
local smw = require("hypr.plugins.split-monitor-workspaces")

local closeWindowBind = hl.bind(super .. " + C", hl.dsp.window.close())

hl.bind(super .. " + Q",         exec(terminal))
hl.bind(super .. " + E",         exec(tuiFileMgr))
hl.bind(super .. " + SHIFT + E", exec(guiFileMgr))

hl.bind(super .. " + SPACE",     exec(os.getenv("HOME") .. "/dotfiles/scripts/menu.sh app"))
hl.bind(super .. " + Escape",    exec(os.getenv("HOME") .. "/dotfiles/scripts/menu.sh sys"))
hl.bind(super .. " + W",         exec(os.getenv("HOME") .. "/dotfiles/scripts/menu.sh wall"))
hl.bind(super .. " + P",         exec(os.getenv("HOME") .. "/dotfiles/scripts/menu.sh proc"))

hl.bind(super .. " + SHIFT + PERIOD", exec(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh next"))
hl.bind(super .. " + SHIFT + COMMA",  exec(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh prev"))
hl.bind(super .. " + SHIFT + SPACE",  exec(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh play"))

hl.bind(super .. " + SHIFT + R",   exec(os.getenv("HOME") .. "/dotfiles/scripts/reload.sh"))
hl.bind(super .. " + SHIFT + M",   exec(os.getenv("HOME") .. "/dotfiles/scripts/monitors.sh disable"))
hl.bind(super .. " + M",           exec(os.getenv("HOME") .. "/dotfiles/scripts/monitors.sh enable"))

hl.bind(super .. " + SHIFT + X", exec(os.getenv("HOME") .. "/dotfiles/scripts/focus.sh"))
hl.bind(super .. " + SHIFT + S", exec("killall hyprsunset || hyprsunset"))
hl.bind(super .. " + SHIFT + L", exec("hyprlock"))

hl.bind("Print",         exec("hyprshot -m region -m active -o ~/Pictures/Screenshots/"))
hl.bind("SHIFT + Print", exec("hyprshot -m region -m output -o ~/Pictures/Screenshots/"))

hl.bind(super .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(super .. " + S",         hl.dsp.layout("togglesplit"))
hl.bind(super .. " + F",         hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(super .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

local dirs = {
  { keys = { "left",  "H" }, dir = "left",  resize = { x = -10, y = 0 } },
  { keys = { "right", "L" }, dir = "right", resize = { x = 10,  y = 0 } },
  { keys = { "up",    "K" }, dir = "up",    resize = { x = 0,   y = -10 } },
  { keys = { "down",  "J" }, dir = "down",  resize = { x = 0,   y = 10 } },
}

for _, d in ipairs(dirs) do
  for _, key in ipairs(d.keys) do
    hl.bind(super .. " + " .. key, hl.dsp.focus({ direction = d.dir }))

    hl.bind(super .. " + SHIFT + " .. key, function()
      hl.dispatch(hl.dsp.window.resize({ x = d.resize.x, y = d.resize.y, relative = true }))
    end)

    hl.bind(super .. " + CTRL + " .. key, hl.dsp.window.swap({ direction = d.dir }))
  end
end

for i = 1, smw.get_amount_of_workspaces() do
    local key = (i == 10) and "0" or tostring(i)
    hl.bind(super .. " + " .. key,         smw.workspace(tostring(i)))
    hl.bind(super .. " + SHIFT + " .. key, smw.move_to_workspace(tostring(i)))
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
hl.bind("XF86AudioPrev",  exec(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh play"), { locked = true })
