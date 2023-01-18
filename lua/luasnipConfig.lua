local ls = require('luasnip')
local loader = require("luasnip.loaders.from_snipmate")
ls.setup({})
loader.lazy_load({ paths = "~/.config/vim-snippets/snippets" })
