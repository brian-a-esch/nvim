local general = require('lsp.general')
require('lspconfig')['clangd'].setup {
  on_attach = function(client, bufnr)
    general.on_attach(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gh', ':ClangdSwitchSourceHeader<CR>', bufopts)
  end,
  cmd = {
    "clangd",
    "--background-index",
  },
}
