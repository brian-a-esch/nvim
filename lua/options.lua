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
-- or the language server diagnostics). Prevents jittering while editting.
vim.o.signcolumn = "yes:2"

-- treesitter for folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- N.B. uncomment this if there are issues with folds, makes it easier to see whats going on 
--vim.o.foldcolumn = '8'
-- By default folds are used. This auto expands fold by default, Using "-vim.o.foldlevel = 99" 
-- was another option but messed with the total fold level. Could have the default fold level
-- set to something small if that seems reasonable?
vim.o.foldlevel = 99

-- Automatically resize splits to be equal when the terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd =",
})

vim.cmd('packadd cfilter')

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.ccs",
  command = "set filetype=ccs"
})
vim.cmd('filetype on')
vim.cmd('filetype plugin on')
