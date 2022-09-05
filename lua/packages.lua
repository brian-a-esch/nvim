-- Use packer for managing plugins. Need to have packer installed, see 
-- https://github.com/wbthomason/packer.nvim#quickstart for instructions
-- For home desktop I used an AUR package
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'neovim/nvim-lspconfig'
	use { "catppuccin/nvim", as = "catppuccin" }
end)
