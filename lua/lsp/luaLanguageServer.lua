require('lspconfig')['sumneko_lua'].setup {
  on_attach = require('lsp.general').on_attach,
  settings = {
    Lua = {
      telemetry = {
        -- This is off by default, but still making sure it always is
        enable = false
      }
    }
  }
}
