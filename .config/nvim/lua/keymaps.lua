vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set

keymap("x", "p", [["_dP]])

keymap("n", "<C-c>", ":nohlsearch<CR>")
keymap("n", "n",     "nzzzv")
keymap("n", "N",     "Nzzzv")

keymap("n", "<C-up>", "<C-u>zz")
keymap("n", "<C-down>", "<C-d>zz")

keymap("v", "<S-up>",   ":m '<-2<CR>gv=gv")
keymap("v", "<S-down>", ":m '>+1<CR>gv=gv")

keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

keymap("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end)

keymap("n", "<leader>e", "<Cmd>Telescope find_files<CR>")
keymap("n", "<leader>f", "<Cmd>Telescope grep_string<CR>")

keymap("n", "<leader>s", "<Cmd>NvimTreeToggle<CR>")

keymap("n", "<leader>x", "<Cmd>Buffers<CR>")
keymap("n", "<TAB>",     "<Cmd>bnext<CR>")
keymap("n", "<S-TAB>",   "<Cmd>bprevious<CR>")

keymap("t", "<ESC>",     "<C-\\><C-n>",   opts)
keymap("n", "<leader>t", "<Cmd>terminal<CR>", opts)

keymap("n", "/",     "<Cmd>SearchBoxMatchAll title=Match<CR>")
keymap("n", "<S-R>", "<Cmd>SearchBoxReplace title='Replace Patern' confirm=menu<CR>")
