local general = require('lsp.general')
require('lspconfig')['clangd'].setup {
  on_init = general.on_init,
  on_attach = function(client, bufnr)
    general.on_attach(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gh', ':ClangdSwitchSourceHeader<CR>', bufopts)
  end,
  cmd = {
    "clangd",
    "--background-index",
    "--header-insertion=never",
    "--ranking-model=decision_forest",
  },
}
