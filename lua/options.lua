-- Enables 24 bit rgb colors
vim.o.termguicolors = true
-- Write swap file to disk every 100ms
vim.o.updatetime = 100
-- Turn line number on
vim.o.number = true
-- Use relative line numbers
vim.o.relativenumber = true
-- Proper directions splits
vim.o.splitright = true
vim.o.splitbelow = true
-- Keep cursor from getting to the top or bottom of buffer
vim.o.scrolloff = 8
-- Have tabs be treated as 2 spaces as the default, and width of
-- 121 as the default. Values are overriden
-- by filetype if there is a ftplugin/ for the filetype
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.colorcolumn = "121"

-- Auto completion for vim "comamnds" (in things in prompt after entering ':')
vim.o.wildmode = "longest:full"

-- Turn mouse on in all modes
vim.o.mouse = 'a'

-- Highlight the line the cursor is on
vim.o.cursorline = true

-- Always show column to the left of the line numbers, (i.e. for gitsigns
-- or the language server diagnostics). Prevents jittering while editting.
vim.o.signcolumn = "yes:2"

-- treesitter for folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- N.B. uncomment this if there are issues with folds, makes it easier to see whats going on 
--vim.o.foldcolumn = '8'
-- By default folds are used. This auto expands fold by default, Using "-vim.o.foldlevel = 99" 
-- was another option but messed with the total fold level. Could have the default fold level
-- set to something small if that seems reasonable?
vim.o.foldlevel = 99

-- Automatically resize splits to be equal when the terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd =",
})

vim.cmd('packadd cfilter')

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.ccs",
  command = "set filetype=ccs"
})
vim.cmd('filetype on')
vim.cmd('filetype plugin on')

-- Enable automatic reread of unchanged buffers, and tracking structures
vim.o.autoread = true
local reloading = false
local reloaded_buffers = {}
local checktime_group = vim.api.nvim_create_augroup("auto_checktime", { clear = true })

-- Logs when a buffer gets loaded
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = checktime_group,
  callback = function(args)
    local buf_name = vim.api.nvim_buf_get_name(args.buf)
    -- Want to aggregate buffers so we can print all that changed
    table.insert(reloaded_buffers, buf_name)
  end,
})

local function checktime_with_callback()
  if reloading then return end
  reloading = true

  -- check all buffers that are different from disk
  vim.cmd("checktime")

  vim.defer_fn(function()
    if #reloaded_buffers > 0 then
      -- "all done" notification
      vim.notify("Finished reloading buffers:\n" .. table.concat(reloaded_buffers, "\n"), vim.log.levels.INFO)
      reloaded_buffers = {} -- reset list

      -- In the future
      -- your global post-reload callback goes here
      -- e.g., require("my_module").reload_state()
    end
    reloading = false
  end, 0)
end

vim.api.nvim_create_autocmd(
  { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
  {
    group = checktime_group,
    callback = checktime_with_callback
  }
)

