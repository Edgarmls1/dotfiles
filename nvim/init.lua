vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.showmode = false
vim.o.swapfile = false
vim.o.autoindent = false
vim.o.scrolloff = 10
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.mouse = "a"
vim.o.background = "dark"
vim.o.clipboard = "unnamedplus"
vim.o.signcolumn = "yes:1"
vim.g.mapleader = " "
vim.opt.listchars = { tab = "| ", trail = "·", nbsp = "␣" }

vim.pack.add { 
	"https://github.com/goolord/alpha-nvim",
	"https://github.com/echasnovski/mini.icons",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/ellisonleao/gruvbox.nvim",
	"https://github.com/catppuccin/nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/romgrk/barbar.nvim",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/VonHeikemen/fine-cmdline.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/sphamba/smear-cursor.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/hrsh7th/cmp-buffer",
	"https://github.com/hrsh7th/cmp-path",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/norcalli/nvim-colorizer.lua",
}

require("render-markdown").enable()
require("lualine").setup()
require("smear_cursor").setup({ opts = {} })
require("gruvbox").setup({ priority = 1000 })
require("nvim-autopairs").setup({ event = "InsertEnter" })
require("alpha").setup(require("alpha.themes.theta").config)
require("nvim-highlight-colors").setup({ render = "virtual" })
require("oil").setup({ view_options = { show_hidden = true } })
require("catppuccin").setup({ priority = 1000, flavor = "mocha", transparent_background = true })
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

vim.lsp.config("gopls", {})
vim.lsp.config("jdtls", {})
vim.lsp.config("clangd", {})
vim.lsp.config("pyright", {})
vim.lsp.config("rust-analyzer", {})
vim.lsp.config("bash-language-server", {})

vim.cmd("lsp enable gopls")
vim.cmd("lsp enable jdtls")
vim.cmd("lsp enable clangd")
vim.cmd("lsp enable pyright")
vim.cmd("lsp enable rust-analyzer")
vim.cmd("lsp enable bash-language-server")

vim.cmd("colorscheme catppuccin-nvim") --theme:cats
--vim.cmd("colorscheme oldTerm") --theme:lain
--vim.cmd("colorscheme gruvbox") --theme:gruvbox

vim.keymap.set("n", "<leader>e", ":Oil<CR>")
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", opts)
vim.keymap.set("n", "<leader>t", ":terminal<CR>", opts)
vim.keymap.set("n", "<TAB>", "<Cmd>BufferNext<CR>", opts)
vim.keymap.set("n", "<S-TAB>", "<Cmd>BufferPrevious<CR>", opts)
vim.keymap.set("n", ":", "<Cmd>FineCmdline<CR>", { noremap = true })

vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
	float = {
		style = "minimal",
		border = "solid",
		header = "",
		prefix = "",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = "»",
		},
	},
})

local cmp = require("cmp")
cmp.setup({
	preselect = "item",
	completion = {
		completeopt = "menu,menuone,noinsert"
	},
	window = {
		documentation = cmp.config.window.bordered(),
	},
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "buffer",  keyword_length = 3 },
	},
	mapping = cmp.mapping.preset.insert({
		["<ENTER>"] = cmp.mapping.confirm({ select = true })
	})	
})
