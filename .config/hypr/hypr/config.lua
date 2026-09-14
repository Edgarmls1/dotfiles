---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
	general = {
		gaps_in  = 5,
		gaps_out = 10,

		border_size = 1,

		col = {
			active_border   = "rgba(dad0cfff)",
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
            enabled           = true,
            size              = 8,
            passes            = 2,
            vibrancy          = 0.1696,
            ignore_opacity    = true,
            new_optimizations = true,
            xray              = true,
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

hl.device({
	name        = "epic-mouse-v1",
	sensitivity = 0.5,
})
