vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local d = ev.data
    if d.kind ~= 'install' and d.kind ~= 'update' then return end

    if d.spec.name == 'telescope-fzf-native.nvim' then
      vim.system({ 'make' }, { cwd = d.path }):wait()
    elseif d.spec.name == 'nvim-treesitter' then
      if not d.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

vim.pack.add({
  -- UI
  "https://github.com/goolord/alpha-nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/ojroques/nvim-bufbar",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/sphamba/smear-cursor.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/brenoprata10/nvim-highlight-colors",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",

  -- Busca
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  "https://github.com/VonHeikemen/searchbox.nvim",

  -- LSP e completion
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/creativenull/efmls-configs-nvim",
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/hrsh7th/cmp-nvim-lsp",

  -- Edição
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/nvim-mini/mini.nvim",
})

require("searchbox")
require("render-markdown").enable()

require("mason").setup()
require("bufbar").setup()
require("nvim-tree").setup()
require("telescope").setup()
require("smear_cursor").setup({ opts = {} })
require("nvim-autopairs").setup({ event = "InsertEnter" })
require("alpha").setup(require("alpha.themes.theta").config)
require("nvim-highlight-colors").setup({ render = "virtual" })
require("mini.cmdline").setup({ autocorrect = { enable = false } })

require("lualine").setup({
    options = {
        theme = 'auto',
        component_separators = { left = '|', right = '|'}
    },
    always_show_tabline = false,
    sections = {
        lualine_a = {{ 'mode', separator = { right = '' } }},
        lualine_b = {{ 'branch', separator = { right = '' } }, { 'diff', separator = { right = '' } }, { 'diagnostics', separator = { right = '' } }},
        lualine_c = {{ 'filename', hide_filename_extension = false }},
        lualine_x = {'lsp_status', 'fileformat', { 'filetype', icon_only = true }, 'filesize'},
        lualine_y = {{ 'progress', separator = { left = '' } }},
        lualine_z = {{ 'location', separator = { left = '' } }}
    }
})

require("mini.notify").setup({
	content = {
		format = function(notif)
			return notif.msg
		end,
	},
})
