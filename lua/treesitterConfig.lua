local configs = require("nvim-treesitter.configs")

configs.setup({
  --ensure_installed = "all", -- one of "all" or a list of languages
  ignore_install = { "" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "css" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = false,
  },
  autopairs = {
    enable = true,
  },
})
