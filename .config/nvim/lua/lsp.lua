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
