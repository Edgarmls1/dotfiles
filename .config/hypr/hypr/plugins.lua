local smw = require("hypr.plugins.split-monitor-workspaces")
smw.setup({
    workspace_count              = 10,
    monitor_priority             = { "DP-1", "eDP-1" },
    keep_focused                 = false,
    enable_notifications         = false,
    enable_persistent_workspaces = false,
    enable_wrapping              = true,
    link_monitors                = false,
})
--
-- smw.max_workspaces({ monitor = "DP-1",     max = 10 })
-- smw.max_workspaces({ monitor = "HDMI-A-2", max = 10 })
