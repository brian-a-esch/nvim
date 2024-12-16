-- Use packer for managing plugins. Need to have packer installed, see
-- https://github.com/wbthomason/packer.nvim#quickstart for instructions
-- For home desktop I used an AUR package
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use { "catppuccin/nvim", as = "catppuccin" }
  use { 'akinsho/bufferline.nvim', tag = "v4.*", requires = 'kyazdani42/nvim-web-devicons' }
  use { "kyazdani42/nvim-tree.lua", requires = 'kyazdani42/nvim-web-devicons' }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
  -- N.B, if we remove this, we need to add a plenary install, since it's used for some custom stuff
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } }
  use { 'akinsho/toggleterm.nvim', tag = '*' }

  -- Auto completion tools. There are things for snippets, in buffer completion. Not sure I want that atm
  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-nvim-lua' }

  -- Gets a single char color column
  use "lukas-reineke/virt-column.nvim"
  use "lewis6991/gitsigns.nvim"
  use "tpope/vim-fugitive"
  use 'skywind3000/asyncrun.vim'
  -- On legacy since they're re-writing, consider upgrading when they're done
  use { 'j-hui/fidget.nvim', tag = "v1.*" }
  use 'windwp/nvim-autopairs'
  use 'RRethy/vim-illuminate'

  use({ "L3MON4D3/LuaSnip", tag = "v1.*" })
  use { 'saadparwaiz1/cmp_luasnip' }

  -- Debugger stuff
  use 'mfussenegger/nvim-dap'

  -- Org mode and org bullets. N.B. orgmode uses treesitter for syntax highlighting
  use { 'nvim-orgmode/orgmode' }
  use { 'akinsho/org-bullets.nvim' }

  use { 'nvim-treesitter/playground' }

  use { 'jghauser/fold-cycle.nvim' }
  use {
    'goolord/alpha-nvim',
    requires = { 'nvim-tree/nvim-web-devicons' }
  }
  use { 'kosayoda/nvim-lightbulb' }

  use 'puremourning/vimspector'
end)
