local telescope = require('telescope')
local builtin = require('telescope.builtin')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local async = require "plenary.async"
local make_entry = require "telescope.make_entry"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

telescope.setup {
  defaults = {
    prompt_prefix = " ",
    layout_config = {
      prompt_position = "top",
      preview_width = 0.65,
    },
    sorting_strategy = "ascending",
    mappings = {
      i = {
        ["<CR>"] = "select_drop"
      }
    },
  },
}

-- So this is odd, but for whatever reason, after a file gets loaded with telescope the
-- folds are not quite set properly, and need to be re-computed. This only crops up here,
-- and if I open a file via `nvim foo.lua`, the folds are set properly. So it really
-- appears to be a problem after files get loaded via telescope. This was pulled from
-- a git issue https://github.com/nvim-telescope/telescope.nvim/issues/559
vim.api.nvim_create_autocmd('BufRead', {
  callback = function()
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      command = 'normal! zx'
    })
  end
})

local opts = { silent = true }
vim.keymap.set("n", "<leader>ff", function() builtin.find_files({ hidden = true }) end, opts)
vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)
vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts)
vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)
vim.keymap.set("n", "<leader>fc", builtin.command_history, opts)
vim.keymap.set("n", "<leader>fi", builtin.current_buffer_fuzzy_find, opts)
vim.keymap.set("n", "<leader>fS", builtin.spell_suggest, opts)
vim.keymap.set("n", "<leader>fs", builtin.lsp_workspace_symbols, opts)
-- These require the lsp, and kind of overrides the "g" key "namespace" which
-- is kind of just used for the lsp commands. But if works really nice
vim.keymap.set("n", "gr", builtin.lsp_references, opts)
vim.keymap.set("n", "gs", builtin.lsp_document_symbols, opts)
vim.keymap.set("n", "gi", builtin.lsp_implementations, opts)
vim.keymap.set("n", "gt", builtin.lsp_type_definitions, opts)
vim.keymap.set("n", "gd", builtin.lsp_definitions, opts)

local SUB_TYPE = {
  lsp_name = "typeHierarchy/subtypes",
  title = "Subtypes",
}

local SUPER_TYPE = {
  lsp_name = "typeHierarchy/supertypes",
  title = "SuperTypes",
}

-- Async function using plenary, needs to be called in async runner context
local function hierarchy_async(type)
  local name = vim.api.nvim_buf_get_name(0)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1 -- Lines are 0 indexed
  local params = {
    textDocument = {
      uri = string.format("file://%s", name),
    },
    position = {
      line = row,
      character = col,
    },
  }

  local res, err = async.lsp.buf_request_all(0, "textDocument/prepareTypeHierarchy", params)
  assert(not err, err)
  -- Technically multiple clients can be attatched, but I'll wait to see that happen
  assert(#res == 1)
  res = res[1].result

  res, err = async.lsp.buf_request_all(0, type.lsp_name, { item = res[1] })
  assert(not err, err)
  assert(#res == 1)
  res = res[1].result
  if res == nil then
    print("No " .. type.lsp_name .. " found")
    return
  end

  local items = {}
  for _, r in ipairs(res) do
    table.insert(items, {
      filename = vim.uri_to_fname(r.uri),
      lnum = r.selectionRange.start.line + 1,
      col = r.selectionRange.start.character + 1,
      text = r.name,
    })
  end

  -- Display them
  pickers.new({}, {
    prompt_title = "Subtypes",
    finder = finders.new_table {
      results = items,
      entry_maker = make_entry.gen_from_quickfix({}),
    },
    previewer = conf.qflist_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

vim.keymap.set('n', "gl", function() async.run(function() hierarchy_async(SUB_TYPE) end) end, opts)
vim.keymap.set('n', "gu", function() async.run(function() hierarchy_async(SUPER_TYPE) end) end, opts)
