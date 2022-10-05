require('illuminate').configure({
  -- providers: provider used to get references in the buffer, ordered by priority
  providers = {
    'lsp',
    'treesitter',
    'regex',
  },
  -- in milliseconds
  delay= 300,
})

-- Colors are found here:
-- https://github.com/catppuccin/nvim/blob/7f9687ce1f551ccb0bd804f614608b5001c6478f/lua/catppuccin/palettes/mocha.lua
-- surface1 seemed to be the best after testing them out. Could go more subtle
-- with surface0 but I think its a nice balance atm
local colors = require("catppuccin.palettes").get_palette()
vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bg = colors.surface1 })
vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = colors.surface1 })
vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bg = colors.surface1 })
