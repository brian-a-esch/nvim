return {

  { "p00f/clangd_extensions.nvim" },

  { "catppuccin/nvim", name = "catppuccin" },

  {
    "kyazdani42/nvim-tree.lua",
    dependencies = { "kyazdani42/nvim-web-devicons" },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    lazy = false,
    --build = ":TSUpdate",
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  { "akinsho/toggleterm.nvim", version = "*" },

  {
    "saghen/blink.cmp",
    version = "v1.*",
    dependencies = {
      "mikavilpas/blink-ripgrep.nvim",
    },
  },

  { "lukas-reineke/virt-column.nvim" },
  { "lewis6991/gitsigns.nvim" },
  { "tpope/vim-fugitive" },
  { "skywind3000/asyncrun.vim" },
  { "j-hui/fidget.nvim", version = "v1.*" },
  { "windwp/nvim-autopairs" },
  { "RRethy/vim-illuminate" },

  -- DAP
  { "mfussenegger/nvim-dap" },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
  },
  { "theHamsta/nvim-dap-virtual-text" },

  -- Org
  { "nvim-orgmode/orgmode" },
  { "akinsho/org-bullets.nvim" },

  --{ "nvim-treesitter/playground" },

  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  { "kosayoda/nvim-lightbulb" },

  {
    "brian-a-esch/codecompanion.nvim",
    branch = "diff-hunks",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MeanderingProgrammer/render-markdown.nvim",
      "echasnovski/mini.diff",
    },
  },

  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
