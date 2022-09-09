-- When entering commands in the prompt, ignore case
vim.o.ignorecase = true
-- Enables 24 bit rgb colors
vim.o.termguicolors = true
-- Write swap file to disk every 100ms
vim.o.updatetime = 100
-- Turn line number on
vim.o.number = true
-- Proper directions splits
vim.o.splitright = true
vim.o.splitbelow = true
-- Keep cursor from getting to the top or bottom of buffer
vim.o.scrolloff = 8
-- Have tabs appear as four spaces, keeping tabstop at 8 though.
-- doc recommendations https://neovim.io/doc/user/options.html#'tabstop'
-- I don't know how this will play with other langauges. For example some
-- projects use 2 spaces for indent. golang projects work with tabs for the
-- indent. This may need to change in the future. From reading on the internet
-- I can add nvim/ftplugin/[filetype].lua (so cpp.lua or something like that)
-- and add language specific overloads. I wonder how this will work for project
-- specific overloads though?
vim.o.tabstop = 8
vim.o.softtabstop = 2
vim.o.shiftwidth = 2

-- Auto completion for vim "comamnds" (in things in prompt after entering ':')
vim.o.wildmode = "longest:full"

-- Turn mouse on in all modes
vim.o.mouse = 'a'
