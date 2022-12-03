local cmp = require('cmp')

local check_backspace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

cmp.setup({
  snippet = {
    -- TODO get an actual snippet engine, this is just from their docs
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#no-snippet-plugin
    -- We recommend using *actual* snippet engine.
    -- It's a simple implementation so it might not work in some of the cases.
    expand = function(args) end,
  },
  mapping = cmp.mapping.preset.insert({
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    --["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    ["<CR>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.close()
      else
        fallback()
      end
    end, { "i", "s" }),
    --["<CR>"] = cmp.maabort(function(fallback)
    --if cmp.visible() then
    --cmp.select_next_item()
    --end
    --cmp.close()
    --end, { "i", "s" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
        -- If luasnip is added, we should add this
        --elseif luasnip.expandable() then
        --luasnip.expand()
        --elseif luasnip.expand_or_jumpable() then
        --luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
        --elseif luasnip.jumpable(-1) then
        --luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    --{ name = 'luasnip' },
    { name = 'buffer' },
  }),

  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(entry, vim_item)
      -- NOTE: order matters
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        buffer = "[Bufer]",
      })[entry.source.name]
      return vim_item
    end,
  },
})
