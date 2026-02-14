local blink_types = require('blink.cmp.types')
local llama = require('llama')
local log = require('log')

-- lua/mywords.lua
--- @class blink.cmp.Source
local source = {}

-- `opts` table comes from `sources.providers.your_provider.opts`
-- You may also accept a second argument `config`, to get the full
-- `sources.providers.your_provider` table
function source.new(opts)
  local self = setmetatable({}, { __index = source })
  self.opts = opts
  return self
end

function source.complete(ctx, callback)
  -- Static list of suggestions
  local words = { "foo", "bar", "baz", "qux" }
  local items = vim.tbl_map(function(w)
    return {
      label = w,
      kind = blink_types.CompletionItemKind.Text,
    }
  end, words)
  callback({ items = items, isIncomplete = false })
end

function source:get_completions(ctx, callback)
  -- ctx (context) contains the current keyword, cursor position, bufnr, etc.

  log:debug("We have been requested to provide a completion")
  local filetype = vim.bo.ft or ''
  llama.fim_inline(function(text)
    if text == nil then
      callback()
    end

    local item = {
      -- Label of the item in the UI
      label = 'some label text',
      -- (Optional) Item kind, where `Function` and `Method` will receive
      -- auto brackets automatically
      kind = blink_types.CompletionItemKind.Text,
      -- (Optional) Text to fuzzy match against
      --filterText = 'bar',
      -- (Optional) Text to use for sorting. You may use a layout like
      -- 'aaaa', 'aaab', 'aaac', ... to control the order of the items
      --sortText = 'baz',
      insertText = text,
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
      documentation = {
        kind = 'markdown',
        value = '```' .. filetype .. '\n' .. text .. '\n```',
        -- Draws the documentation with treesitter markdown
        draw = function(opts) opts.default_implementation() end,
      },
    }

    log:info("We are going to send completion %s back", text)
    callback({
      items = { item },
      -- Whether blink.cmp should request items when deleting characters
      -- from the keyword (i.e. "foo|" -> "fo|")
      -- Note that any non-alphanumeric characters will always request
      -- new items (excluding `-` and `_`)
      is_incomplete_backward = false,
      -- Whether blink.cmp should request items when adding characters
      -- to the keyword (i.e. "fo|" -> "foo|")
      -- Note that any non-alphanumeric characters will always request
      -- new items (excluding `-` and `_`)
      is_incomplete_forward = false,
      item
    })
  end)
  -- (Optional) Return a function which cancels the request
  -- If you have long running requests, it's essential you support cancellation
  -- TODO actually work with cancellation
  return function() end
end

return source
