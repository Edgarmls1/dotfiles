local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font_size = 12
config.font = wezterm.font("Hack Nerd Font")
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.7
config.exit_behavior = "CloseOnCleanExit"
config.exit_behavior_messaging = "None"
config.window_close_confirmation = "NeverPrompt"

-- config.color_scheme = "3024 Night"

config.colors = {
    background    = "#171717",
    foreground    = "#ffffff",
    cursor_bg     = "#ffffff",
    cursor_fg     = "#000000",
    cursor_border = "#ffffff",
    selection_fg  = "#181818",
    selection_bg  = "#ffffff",

    ansi = {
        "#282828",
        "#a35b5b",
        "#7f9f7f",
        "#bfa97a",
        "#6f8fae",
        "#9f7fac",
        "#7aa3a3",
        "#d0d0d0",
    },

    brights = {
        "#3c3c3c",
        "#c17d7d",
        "#a0c0a0",
        "#d9c497",
        "#8fb0d0",
        "#bfa0cc",
        "#99c2c2",
        "#f0f0f0",
    },
}

return config
