local clang_extentions = require("clangd_extensions")

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

-- Language server stuff, should pull into separate files
local function on_attach(client, bufnr)
  if client.server_capabilities then
    client.server_capabilities.semanticTokensProvider = nil -- turn off semantic tokens
  end

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
  vim.keymap.set("n", '<leader>h', function()
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

-- Sets up general configs. Specific configs for each language server override the defaults
vim.lsp.config("*", {
  root_markers = { '.git' },
})

vim.lsp.config('clangd', {
  cmd = {
    "clangd",
    "--background-index",
    "--header-insertion=never",
    "--ranking-model=decision_forest",
  },
  filetypes = { 'c', 'cpp' },
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.keymap.set('n', 'gh', ':ClangdSwitchSourceHeader<CR>', { noremap = true, silent = true, buffer = bufnr })
  end
})

vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      diagnostics = { globals = { "vim" } },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          vim.env.VIMRUNTIME
        },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    }
  },
})

-- Did not test this one out
vim.lsp.config('pyright', {
  cmd = { "pyright" },
  filetypes = { "python" },
  on_attach = on_attach,
})

vim.lsp.config('rust_analyzer', {
  -- The rust_analyzer does not get tossed into the ~/.cargo/bin
  -- directory like most rust tools. The actual location of the install
  -- can be found with "rustup which --toolchain stable rust-analyzer" but
  -- it just seems easier to use "rustup" to run the analyzer, and things
  -- should be picked up correctly this way
  -- https://rust-analyzer.github.io/manual.html#rustup
  -- https://github.com/rust-lang/rustup/issues/2411
  cmd = { "rustup", "run", "stable", "rust-analyzer" },
  filetypes = { "rust" },
  on_attach = on_attach,
})

vim.lsp.config('tsserver', {
  cmd = { "typescript-language-server", "--stdio" },
  -- Not totally sure these are right?
  filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  on_attach = on_attach,
})

vim.lsp.config('zls', {
  cmd = { 'zls' },
  filetypes = { "zig" },
  on_attach = on_attach,
})

vim.lsp.enable('clangd')
vim.lsp.enable('lua_ls')
vim.lsp.enable('pyright')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('tsserver')
vim.lsp.enable('zls')

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    border = "rounded",
    -- This is what it was, is "true" satisfactory?
    --source = "always",
    source = true,
    header = "",
    prefix = "",
  },
})

clang_extentions.setup()
