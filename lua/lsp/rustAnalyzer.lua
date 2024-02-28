local general = require('lsp.general')

require 'lspconfig'.rust_analyzer.setup({
  -- The rust_analyzer does not get tossed into the ~/.cargo/bin
  -- directory like most rust tools. The actual location of the install
  -- can be found with "rustup which --toolchain stable rust-analyzer" but
  -- it just seems easier to use "rustup" to run the analyzer, and things
  -- should be picked up correctly this way
  -- https://rust-analyzer.github.io/manual.html#rustup
  -- https://github.com/rust-lang/rustup/issues/2411
  cmd = { "rustup", "run", "stable", "rust-analyzer" },
  on_init = require('lsp.general').on_init,
  on_attach = function(client, bufnr)
    general.on_attach(client, bufnr)

    --vim.api.nvim_create_autocmd("BufWritePre",
      --{ pattern = '*', callback = vim.lsp.buf.formatting_sync })
  end,
})
