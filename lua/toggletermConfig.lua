require("toggleterm").setup {
  size = 20,
  -- We don't want to use a leader key, because we need to escape the
  -- the terminal with keys which are not going to be used in the terminal
  open_mapping = [[<C-\>]],
  -- I like the terminal that pops up and then goes away. In the future
  -- if we don't want to use "float" for the terminal, we should also
  -- set up some key bindings which allow us to move cleanly between the
  -- terminal and the main screen
  direction = "float",
}

local Terminal = require('toggleterm.terminal').Terminal
local opts     = { noremap = true, silent = true }

vim.keymap.set("n", '<leader>gH', function()
  local filename = vim.api.nvim_buf_get_name(0) -- 0 is current
  local logTerminal = Terminal:new({
    cmd = "tig --full-diff " .. filename
  })
  logTerminal:toggle()
end, opts)

