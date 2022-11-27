local telescope = require('telescope')

telescope.setup{
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

