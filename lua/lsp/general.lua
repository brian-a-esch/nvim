local M = {}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)
end

-- Function to get all floating windows
local function has_floating_window()
  local windows = vim.api.nvim_list_wins()
  for _, win_id in ipairs(windows) do
    local win_config = vim.api.nvim_win_get_config(win_id)
    -- A window is considered floating if 'relative' is set to anything other than an empty string
    if win_config.relative ~= "" then
      return true
    end
  end
  return false
end

vim.lsp.handlers["textDocument/hover"] = function (_, result, ctx, config)
  config = config or {}
  config.border = "rounded"
  vim.lsp.handlers.hover(_, result, ctx, config)
end

-- Language server stuff, should pull into separate files
M.on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  -- This is what it is in clion, maybe change?
  vim.keymap.set('i', '<C-p>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<C-p>', vim.lsp.buf.hover, bufopts)
  -- These are workspace commands. Typically  I just start neovim in a project directory
  -- so these are not needed to manually configure the lsp
  --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  --vim.keymap.set('n', '<space>wl', function()
  --print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  --end, bufopts)
  vim.keymap.set('n', 'gc', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, bufopts)
  -- Using telescope for this
  --vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

  -- In visual mode it will select the last highlighted and format that range, if the lsp
  -- supports that. In normal mode the whole file will be re-formatted
  vim.keymap.set({ 'n', 'v' }, 'gq', '<cmd>lua vim.lsp.buf.format()<CR><ESC>', bufopts)

  -- Default to type hints being on, add toggle option
  vim.lsp.inlay_hint.enable(true)
  vim.keymap.set("n", '<leader>a', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end)

  vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
      -- If we have other floating windows, don't open this up. Setting zindex seems to be insufficient,
      -- specifically for the "hover" preview
      if has_floating_window() then
        return
      end
      vim.diagnostic.open_float({
        scope = 'line',
        -- Keep diagnostics below gitsigns and other popups. Don't know
        -- a truly "best" number for this, but it works for now
        zindex = 1,
      })
    end
  })
end

M.on_init = function(client, initialization_result)
  if client.server_capabilities then
    client.server_capabilities.semanticTokensProvider = false -- turn off semantic tokens
  end
end

return M
