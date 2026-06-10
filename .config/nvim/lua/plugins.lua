vim.pack.add({ 
	"https://github.com/aditya-azad/candle-grey.git",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/echasnovski/mini.icons",
	"https://github.com/goolord/alpha-nvim",
	"https://github.com/hrsh7th/cmp-buffer",
	"https://github.com/hrsh7th/cmp-path",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/norcalli/nvim-colorizer.lua",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/sphamba/smear-cursor.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/VonHeikemen/fine-cmdline.nvim",
	"https://github.com/VonHeikemen/searchbox.nvim",
	"https://github.com/windwp/nvim-autopairs",
})

require("searchbox")
require("render-markdown").enable()

require("lualine").setup()
require("telescope").setup()
require("smear_cursor").setup({ opts = {} })
require("nvim-autopairs").setup({ event = "InsertEnter" })
require("alpha").setup(require("alpha.themes.theta").config)
require("nvim-highlight-colors").setup({ render = "virtual" })
require("oil").setup({ view_options = { show_hidden = true } })
require("mini.cmdline").setup({ autocorrect = { enable = false } })

require("fine-cmdline").setup({
	popup = {
		size = {
				width = "30%",
		},
		border = {
				style = "rounded",
		},
	},
	cmdline = {
		prompt = ":",
	},
})

require("mini.notify").setup({
	content = {
		format = function(notif)
			return notif.msg
		end,
	},
})

