local cmp = require('cmp')

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
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
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
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
