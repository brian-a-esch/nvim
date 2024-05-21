local orgmode = require('orgmode')
local org_bullets = require('org-bullets')

DEFAULT_ORG_FILE = '~/.config/nvim/org/default.org'

orgmode.setup{
  org_default_notes_file = DEFAULT_ORG_FILE,
}
org_bullets.setup({
  concealcursor = true,
})

vim.keymap.set("n", "<leader>oo", ":vsp " .. DEFAULT_ORG_FILE .. "<CR>", { silent = true })
