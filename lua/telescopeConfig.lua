local telescope = require('telescope')

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

local builtin = require('telescope.builtin')
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
