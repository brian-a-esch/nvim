local general = require('lsp.general')

require 'lspconfig'.tsserver.setup {
  on_attach = function(client, bufnr)
    general.on_attach(client, bufnr)
  end,
  cmd = { "typescript-language-server", "--stdio" }
}
