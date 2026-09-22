local lsp = vim.lsp

local function ensure_mason_packages(packages)
	local ok_mr, mr = pcall(require, "mason-registry")
	if not ok_mr then
		vim.notify("mason-registry não encontrado; pulando verificação de LSPs", vim.log.levels.WARN)
		return
	end
 
	local to_install = {}
	for _, name in ipairs(packages) do
		local ok_pkg, pkg = pcall(mr.get_package, name)
		if ok_pkg and not pkg:is_installed() then
			table.insert(to_install, name)
		end
	end
 
	if #to_install > 0 then
		vim.notify("Instalando via Mason: " .. table.concat(to_install, ", "), vim.log.levels.INFO)
		vim.cmd("MasonInstall " .. table.concat(to_install, " "))
	end
end
 
ensure_mason_packages({
	"gopls",
    "jdtls",
	"pyright",
	"clangd",
	"css-lsp",
    "luacheck",
	"html-lsp",
	"bash-language-server",
	"typescript-language-server",
})

lsp.config("gopls", {})
lsp.config("jdtls", {})
lsp.config("ts_ls", {})
lsp.config("clangd", {})
lsp.config("bashls", {})
lsp.config("pyright", {})
lsp.config("css-lsp", {})
lsp.config("html-lsp", {})

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
            [vim.diagnostic.severity.WARN]  = "▲",
            [vim.diagnostic.severity.HINT]  = "⚑",
            [vim.diagnostic.severity.INFO]  = "»",
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

do
	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")

	local ruff_lint = require("efmls-configs.linters.ruff")
	local ruff_format = require("efmls-configs.formatters.ruff")

	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local eslint_d = require("efmls-configs.linters.eslint_d")

	local fixjson = require("efmls-configs.formatters.fixjson")

	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")

	local cpplint = require("efmls-configs.linters.cpplint")
	local clangfmt = require("efmls-configs.formatters.clang_format")

	local go_revive = require("efmls-configs.linters.go_revive")
	local gofumpt = require("efmls-configs.formatters.gofumpt")

	lsp.config("efm", {
		filetypes = {
			"c",
			"cpp",
			"css",
			"go",
			"html",
			"javascript",
			"javascriptreact",
			"json",
			"jsonc",
			"lua",
			"markdown",
			"python",
			"sh",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
		},
		init_options = { documentFormatting = true },
		settings = {
			languages = {
				c = { clangfmt, cpplint },
				go = { gofumpt, go_revive },
				cpp = { clangfmt, cpplint },
				css = { prettier_d },
				html = { prettier_d },
				javascript = { eslint_d, prettier_d },
				javascriptreact = { eslint_d, prettier_d },
				json = { eslint_d, fixjson },
				jsonc = { eslint_d, fixjson },
				lua = { luacheck, stylua },
				markdown = { prettier_d },
				python = { ruff_lint, ruff_format },
				sh = { shellcheck, shfmt },
				typescript = { eslint_d, prettier_d },
				typescriptreact = { eslint_d, prettier_d },
				vue = { eslint_d, prettier_d },
				svelte = { eslint_d, prettier_d },
			},
		},
	})
end

lsp.enable({
    "efm",
    "gopls",
    "jdtls",
    "ts_ls",
    "clangd",
    "bashls",
    "pyright",
    "css-lsp",
    "html-lsp",
})
