local orgmode = require('orgmode')
local org_bullets = require('org-bullets')

local default_file = '~/.config/nvim/org/default.org'

orgmode.setup{
  org_default_notes_file = default_file,
}
orgmode.setup_ts_grammar()
org_bullets.setup({
  concealcursor = true,
})

vim.keymap.set("n", "<leader>oo", ":vsp " .. default_file .. "<CR>", { silent = true })
