local gs = require('gitsigns')
local gl = require('gitlinker')
local gl_actions = require("gitlinker.actions")
local gl_hosts = require("gitlinker.hosts")

local get_blame_sha = function()
  -- So this uses a "buffer variable" which gets set by the current line blame
  -- code below. This does mean if the delay is set high enough, we won't get
  -- the sha. Could be better to open an issue to expose a way to get this
  local bufnr = vim.api.nvim_get_current_buf()
  local sha = vim.b[bufnr].gitsigns_blame_line_dict.sha
  if sha == "0000000000000000000000000000000000000000" then
    return nil
  end
  return sha
end

-- Gitsigns writes to the index behind fugitive's back, so open :G status
-- buffers don't notice until we fire FugitiveChanged ourselves.
local function refresh_fugitive()
  vim.schedule(function()
    if vim.fn.exists('*fugitive#DidChange') == 1 then
      vim.fn['fugitive#DidChange']()
    else
      vim.cmd('silent! doautocmd User FugitiveChanged')
    end
  end)
end

local function visual_range()
  return { vim.fn.line('.'), vim.fn.line('v') }
end

gs.setup {
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 500,
    ignore_whitespace = false,
  },
  -- Make priority HIGHER than lsp. This in conjunction with increasing the
  -- "signcolumn" size to 2 makes it so gitsigns and an lsp error can both display
  sign_priority = 20,
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
      vim.schedule(function() gs.nav_hunk("next", { target = "all" }) end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[g', function()
      if vim.wo.diff then return '[g' end
      vim.schedule(function() gs.nav_hunk("prev", { target = "all" }) end)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    map('n', '<leader>gs', function() gs.stage_hunk(nil, nil, refresh_fugitive) end)
    map('v', '<leader>gs', function() gs.stage_hunk(visual_range(), nil, refresh_fugitive) end)
    map({ 'n', 'v' }, '<leader>gr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>gS', function() gs.stage_buffer(refresh_fugitive) end)
    map('n', '<leader>gu', function() gs.undo_stage_hunk(refresh_fugitive) end)
    map('n', '<leader>gR', gs.reset_buffer)
    map('n', '<leader>gp', gs.preview_hunk)
    map('n', '<leader>gb', ':Gitsigns blame<CR>')
    map('n', '<leader>gq', ':Gitsigns setqflist all<CR>')
    map('n', '<leader>gd', function()
      local sha = get_blame_sha()
      if sha == nil then
        gs.diffthis()
      else
        gs.diffthis(sha .. '~')
      end
    end)
    map('n', '<leader>gD', function() gs.diffthis('~') end)
  end,
}

gl.setup{
  -- default mapping to copy to clipboard
  mappings = "<leader>gl",
  callbacks = {
    ["git.drwholdings.com"] = gl_hosts.get_github_type_url,
  }
}
vim.keymap.set('n', '<leader>gL', function()
  gl.get_buf_range_url('n', { action_callback =
        function(url)
          gl_actions.copy_to_clipboard(url)
          gl_actions.open_in_browser(url)
        end
})
end, {silent = true})

local Terminal = require('toggleterm.terminal').Terminal
local termOpts = { noremap = true, silent = true }

vim.keymap.set("n", '<leader>gB', function()
  local cmd = 'tig show ' .. get_blame_sha()
  local logTerminal = Terminal:new({ cmd = cmd })
  logTerminal:toggle()
end, termOpts)
