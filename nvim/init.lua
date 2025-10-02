vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.mouse = "a"
vim.o.swapfile = false
vim.o.autoindent = true
vim.o.scrolloff = 10
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.list = true
vim.opt.listchars = { tab = '| ', trail = '·', nbsp = '␣' }

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'goolord/alpha-nvim',
    dependencies = { 'echasnovski/mini.icons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.opt.background = "dark"
      vim.cmd("colorscheme gruvbox")
    end,
  },
  {"stevearc/oil.nvim",},
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,
        ts_config = {
          lua = {'string'},
          javascript = {'template_string'},
          java = false,
        }
      })
    end
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "jsonls",
		  "gopls",
		  "rust-analyzer",
        },
        automatic_installation = true,
      })
    end
  },
  {
	  "nvim-lualine/lualine.nvim",
	  dependencies = {
		"nvim-tree/nvim-web-devicons"
	  },
	  opts = {
		  theme = "gruvbox"
	  }
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',

        build = 'make',

        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
    end,
  },
  {
  	'saghen/blink.cmp',
  	dependencies = { 'rafamadriz/friendly-snippets' },
	version = "*",
  	---@module 'blink.cmp'
  	---@type blink.cmp.Config
  	opts = {
    	keymap = {
      		preset = 'none',
      		['<Up>'] = { 'select_prev', 'fallback' },
      		['<Down>'] = { 'select_next', 'fallback' },
			['<CR>'] = { 'accept', 'fallback' },
		},

    	appearance = {
      	nerd_font_variant = 'mono'
    	},

    	completion = { documentation = { auto_show = false } },

    	sources = {
      	default = { 'lsp', 'path', 'snippets', 'buffer' },
    	},

    	fuzzy = { implementation = "prefer_rust_with_warning" }
  		},
  		opts_extend = { "sources.default" }
  },
  {
	'romgrk/barbar.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      insert_at_start = false,
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
  	'VonHeikemen/fine-cmdline.nvim',
  	dependencies = { 'MunifTanjim/nui.nvim' }
  }
})

require "oil".setup({ view_options = { show_hidden = true } })
require "render-markdown".enable()
require "fine-cmdline".setup({
	popup = {
		size = {
			width = "30%"
		},
		border = {
			style = "rounded"
		}
	},
	cmdline = {
		prompt = ""
	}
})

vim.lsp.enable({
  "lua_ls",
  "gopls",
  "pyright",
  "jsonls",
  "rust_analyzer",
})

vim.keymap.set('n', '<TAB>', '<Cmd>BufferNext<CR>', opts)
vim.keymap.set('n', '<leader>e', ":Oil<CR>")
vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', {noremap = true})
