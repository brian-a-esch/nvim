local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

-- Somtimes on the internet there are normal vim re-mapping configs, 
-- here's an exmplanation of them
-- Commands                        Mode
-----------                        ----
-- nmap, nnoremap, nunmap          Normal mode
-- imap, inoremap, iunmap          Insert and Replace mode
-- vmap, vnoremap, vunmap          Visual and Select mode
-- xmap, xnoremap, xunmap          Visual mode
-- smap, snoremap, sunmap          Select mode
-- cmap, cnoremap, cunmap          Command-line mode
-- omap, onoremap, ounmap          Operator pending mode

-- Sets Leader to space
vim.g.mapleader = " "

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows. Test out with three or more tabs, thats
-- when it gets fun. Regrettably vim seems to pin window sizes to the top
-- left of the window. This makes resizing not feel right for the farthest
-- right window, or the bottom window. Just use mouse?
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Set up tab movement to be like vimium, the chrome extension
keymap("n", "J", ":bprevious<CR>", opts)
keymap("n", "K", ":bnext<CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Toggle NvimTree
keymap("n", "<leader>t", ":NvimTreeToggle<CR>", opts)
-- Load current file in NvimTree
keymap("n", "<leader>r", ":NvimTreeFindFile<CR>", opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

