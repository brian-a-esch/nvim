-- Enables 24 bit rgb colors
vim.o.termguicolors = true
-- Write swap file to disk every 100ms
vim.o.updatetime = 100
-- Turn line number on
vim.o.number = true
-- Use relative line numbers
vim.o.relativenumber = true
-- Proper directions splits
vim.o.splitright = true
vim.o.splitbelow = true
-- Keep cursor from getting to the top or bottom of buffer
vim.o.scrolloff = 8
-- Have tabs be treated as 2 spaces as the default, and width of 
-- 121 as the default. Values are overriden
-- by filetype if there is a ftplugin/ for the filetype
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.colorcolumn = "121"

-- Auto completion for vim "comamnds" (in things in prompt after entering ':')
vim.o.wildmode = "longest:full"

-- Turn mouse on in all modes
vim.o.mouse = 'a'

-- Highlight the line the cursor is on
vim.o.cursorline = true

-- Always show column to the left of the line numbers, (i.e. for gitsigns
-- or the language server diagnostics). Prevents jittering while editting
vim.o.signcolumn = "yes"

-- TODO use treesitter for folds. Should be something like this
--vim.o.foldenable = true
--vim.o.foldmethod = "expr"
--vim.o.foldexpr = "nvim_treesitter#foldexpr()"
-- By default folds are used. This auto expands fold by default
--vim.o.foldlevel = 99
