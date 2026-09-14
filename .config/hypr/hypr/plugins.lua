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
        gloview = {
            switch_animation = 0,
            move_animation   = 0,
        },
    },
})

local smw = hl.plugin.split_monitor_workspaces
smw.monitor_priority({ "DP-1", "HDMI-A-2" })

smw.max_workspaces({ monitor = "DP-1",     max = 10 })
smw.max_workspaces({ monitor = "HDMI-A-2", max = 10 })
