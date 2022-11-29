local gs = require('gitsigns')

local get_blame_sha = function()
  -- So this uses a "buffer variable" which gets set by the current line blame 
  -- code below. This does mean if the delay is set high enough, we won't get
  -- the sha. Could be better to open an issue to expose a way to get this
  local bufnr = vim.api.nvim_get_current_buf()
  return vim.b[bufnr].gitsigns_blame_line_dict.sha
end

gs.setup{
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 0,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <abbrev_sha>, <author_time:%Y-%m-%d> - <summary>',
  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']g', function()
      if vim.wo.diff then return ']g' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[g', function()
      if vim.wo.diff then return '[g' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>gs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>gr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>gS', gs.stage_buffer)
    map('n', '<leader>gu', gs.undo_stage_hunk)
    map('n', '<leader>gR', gs.reset_buffer)
    map('n', '<leader>gp', gs.preview_hunk)
    map('n', '<leader>gb', function() gs.blame_line{full=true} end)
    map('n', '<leader>gd', gs.diffthis)
    map('n', '<leader>gD', function() gs.diffthis('~') end)
    map('n', '<leader>gh', gs.select_hunk)
  end,
}

local Terminal  = require('toggleterm.terminal').Terminal
local termOpts = { noremap = true, silent = true }

vim.keymap.set("n", '<leader>gB', function()
  local cmd = 'tig show ' .. get_blame_sha()
  local logTerminal = Terminal:new({ cmd = cmd })
  logTerminal:toggle()
end, termOpts)
