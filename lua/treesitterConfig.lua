local configs = require("nvim-treesitter.configs")

configs.setup({
  --ensure_installed = "all", -- one of "all" or a list of languages
  ignore_install = { "" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "css" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = { 'org' },
  },
  autopairs = {
    enable = true,
  },
  -- This got removed when updating, apparently there is no more orgmode treesitter 
  -- support? I deleted the .so file after updating, and orgmode still works. Leaving this
  -- call to "ensure_installed" commented out in case I need to re-add
  --ensure_installed = {'org'}, -- Or run :TSUpdate org
})
