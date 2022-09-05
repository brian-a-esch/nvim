-- Use packer for managing plugins. Need to have packer installed, see 
-- https://github.com/wbthomason/packer.nvim#quickstart for instructions
-- For home desktop I used an AUR package
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'neovim/nvim-lspconfig'
	use { "catppuccin/nvim", as = "catppuccin" }
end)

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
vim.o.softtabstop = 4
vim.o.shiftwidth = 4


-- Sets Leader to space
vim.g.mapleader = " "

vim.g.catppuccin_flavour = "mocha" -- Options are; latte, frappe, macchiato, mocha
vim.cmd "colorscheme catppuccin"

-- Language server stuff, should pull into separate files
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

require('lspconfig')['clangd'].setup{
	on_attach = on_attach,
	cmd = {
		"clangd",
		"--background-index",
	},
}
