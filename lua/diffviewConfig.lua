local diffview = require('diffview')

-- I don't have any special configs for this atm
diffview.setup()

local diffview_open = false
local group = vim.api.nvim_create_augroup("diffview_listen", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "DiffviewViewOpened",
  callback = function ()
    diffview_open = true
  end
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "DiffviewViewClosed",
  callback = function ()
    diffview_open = false
  end
})

vim.keymap.set("n", "<leader>dd", function ()
  if diffview_open then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("DiffviewOpen")
  end
end, { silent = true })
