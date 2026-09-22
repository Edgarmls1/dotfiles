local opt = vim.opt
local cmd = vim.cmd

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 10
opt.sidescrolloff = 10
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = false
opt.smartindent = true
opt.inccommand = "split"
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.signcolumn = "yes"
opt.colorcolumn = "100"
opt.showmatch = true
opt.cmdheight = 0
opt.termguicolors = true
opt.completeopt = "menuone,noinsert,noselect"
opt.showmode = false
opt.clipboard = "unnamedplus"
opt.isfname:append("@-@")
opt.mouse = "a"
opt.background = "dark"

cmd.colorscheme("classic")

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end,
})

local undodir = vim.fn.expand("~/.vim/undodir")
if 
    vim.fn.isdirectory(undodir) == 0 
then
    vim.fn.mkdir(undodir, "p")
end

opt.swapfile = false
opt.writebackup = false
opt.backup = false
opt.undofile = true
opt.undodir = undodir
opt.updatetime = 300
opt.timeoutlen = 500
opt.ttimeoutlen = 0
opt.autoread = true
opt.autowrite = false
