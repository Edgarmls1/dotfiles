vim.g.mapleader = " "

vim.keymap.set("x", "p", [["_dP]])

vim.keymap.set("n", "<C-c>", ":nohl<CR>")

vim.keymap.set("v", "<S-up>",   ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<S-down>", ":m '>+1<CR>gv=gv")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end)

vim.keymap.set("n", "<leader>e", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>f", ":Telescope live_grep<CR>")

vim.keymap.set("t", "<ESC>",     "<C-\\><C-n>",   opts)
vim.keymap.set("n", "<leader>t", ":terminal<CR>", opts)

vim.keymap.set("n", "<TAB>",     "<Cmd>BufferNext<CR>",     opts)
vim.keymap.set("n", "<S-TAB>",   "<Cmd>BufferPrevious<CR>", opts)
vim.keymap.set("n", "<leader>c", "<Cmd>BufferClose<CR>",    opts)

vim.keymap.set("n", ":", "<Cmd>FineCmdline<CR>", { noremap = true })

vim.keymap.set("n", "/",     "<Cmd>SearchBoxMatchAll title=Match<CR>")
vim.keymap.set("n", "<S-R>", "<Cmd>SearchBoxReplace title='Replace Patern' confirm=menu<CR>")
