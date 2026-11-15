local smw = require("hypr.plugins.split-monitor-workspaces")
smw.setup({
    workspace_count              = 10,
    monitor_priority             = { "DP-1", "HDMI-A-2" },
    keep_focused                 = false,
    enable_notifications         = false,
    enable_persistent_workspaces = false,
    enable_wrapping              = true,
    link_monitors                = false,
})
