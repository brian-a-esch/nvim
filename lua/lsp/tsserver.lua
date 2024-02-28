local general = require('lsp.general')

require 'lspconfig'.tsserver.setup {
  on_init = require('lsp.general').on_init,
  on_attach = function(client, bufnr)
    general.on_attach(client, bufnr)
  end,
  cmd = { "typescript-language-server", "--stdio" }
}
