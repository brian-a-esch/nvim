require("catppuccin").setup({
  flavour = "mocha",
  integrations = {
    gitsigns = true,
    treesitter = true,
  }
})
vim.cmd("colorscheme catppuccin")
