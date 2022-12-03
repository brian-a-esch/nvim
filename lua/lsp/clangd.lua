require('lspconfig')['clangd'].setup {
  on_attach = require('lsp.general').on_attach,
  cmd = {
    "clangd",
    "--background-index",
  },
}
