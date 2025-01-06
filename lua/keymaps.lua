local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

-- Somtimes on the internet there are normal vim re-mapping configs,
-- here's an exmplanation of them
-- Commands                        Mode
-----------                        ----
-- nmap, nnoremap, nunmap          Normal mode
-- imap, inoremap, iunmap          Insert and Replace mode
-- vmap, vnoremap, vunmap          Visual and Select mode
-- xmap, xnoremap, xunmap          Visual mode
-- smap, snoremap, sunmap          Select mode
-- cmap, cnoremap, cunmap          Command-line mode
-- omap, onoremap, ounmap          Operator pending mode

-- Sets Leader to space
vim.g.mapleader = " "

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows. Test out with three or more tabs, thats
-- when it gets fun. Regrettably vim seems to pin window sizes to the top
-- left of the window. This makes resizing not feel right for the farthest
-- right window, or the bottom window. Just use mouse?
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Set up tab movement to be like vimium, the chrome extension
keymap("n", "J", ":bprevious<CR>", opts)
keymap("n", "K", ":bnext<CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Toggle NvimTree
keymap("n", "<leader>tt", ":NvimTreeToggle<CR>", opts)
-- Load current file in NvimTree
keymap("n", "<leader>tr", ":NvimTreeFindFile<CR>", opts)

keymap("n", "]b", ":cn<CR>", opts)
keymap("n", "[b", ":cN<CR>", opts)
-- Toggle for quickfix
keymap("n", "<leader>b", function()
  local open = false
  for _, i in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(i)
    local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
    if buftype == "quickfix" then
      open = true
      break
    end
  end

  if open then
    vim.cmd(":cclose")
  else
    -- Quickfix menu, open on bottom of screen
    vim.cmd(":botright copen 30")
  end
end, opts)

-- Navigate by diagnostic errors and warnings. Plays well with LSP diagnostics
keymap("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, opts)
keymap("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, opts)
keymap("n", "]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end, opts)
keymap("n", "[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end, opts)

-- Load last 200 commits, loading entire history is slow
keymap("n", "<leader>gl", ":vert G log --stat --decorate -200<CR>", opts)
keymap("n", "<leader>gg", ":vert G<CR>", opts)

-- Refactor tool
keymap("n", "<leader>r", function ()
  package.loaded.refactor = nil
  require('refactor').run()
end)

-- Do not add quickfix list to the buffer list. This makes it so
-- swithcing between buffers does not include quickfix list. The
-- quickfix list can still be found by ":ls!" if really needed.
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "qf",
  command = "set nobuflisted",
})

-- setup copy and paste to go through leader keys
keymap("v", "<leader>y", '"+y')
keymap({ "n", "v" }, "<leader>p", '"+p')
keymap({ "n", "v" }, "<leader>P", '"+P')

--local fold_cycle = require('fold-cycle')
--fold_cycle.setup()
--keymap("n", "<tab>", fold_cycle.open)
--keymap("n", "<s-tab>", fold_cycle.close_all)
---- I think this is just a more sensible default
--keymap("n", "zC", fold_cycle.close_all)

keymap("n", "<leader>cg", function()
  vim.api.nvim_feedkeys(":AsyncRun git grep -n ", "n", false)
  vim.cmd(":botright copen 30")
end, opts)

-- I would really like this to be done with just <tab> in normal mode, but apparently this also
-- effects <C-i> (which is used for history navigation), because many terminals interpret 
-- them as the same input. To solve this in a cross platform & terminal indent way seems hard
-- https://www.reddit.com/r/neovim/comments/14su13t/how_to_map_tab_but_not_affect_ci/
-- https://github.com/alacritty/alacritty/issues/4451
keymap("n", "<leader><tab>", 'za', opts)
