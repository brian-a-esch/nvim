-- Use packer for managing plugins. Need to have packer installed, see 
-- https://github.com/wbthomason/packer.nvim#quickstart for instructions
-- For home desktop I used an AUR package
return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'neovim/nvim-lspconfig'
	use { "catppuccin/nvim", as = "catppuccin" }
	use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}
	use { "kyazdani42/nvim-tree.lua", requires = 'kyazdani42/nvim-web-devicons' }
	use { 'nvim-treesitter/nvim-treesitter', run = function() require('nvim-treesitter.install').update({ with_sync = true }) end }
	use { 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { {'nvim-lua/plenary.nvim'} } }
	use { 'akinsho/toggleterm.nvim', tag = '*' }

	-- Auto completion tools. There are things for snippets, in buffer completion. Not sure I want that atm
	use { 'hrsh7th/nvim-cmp' }
	use { 'hrsh7th/cmp-nvim-lsp' }
	use { 'hrsh7th/cmp-buffer' }

	-- Gets a single char color column
	use "lukas-reineke/virt-column.nvim"
end)
