vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- vim.opt.wrap = false
vim.opt.autoindent = false
vim.opt.smartindent = true
vim.opt.inccommand = "split"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undudir"
vim.opt.undofile = true

vim.opt.clipboard = "unnamedplus"
vim.opt.isfname:append("@-@")
vim.opt.scrolloff = 10

vim.opt.signcolumn = "yes:1"
vim.opt.cmdheight = 0
vim.opt.showmode = false
vim.opt.termguicolors = true

vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.background = "dark"

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end,
})
