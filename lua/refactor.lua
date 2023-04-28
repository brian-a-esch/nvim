local M = {}

local function dump(tbl)
  vim.api.nvim_echo({ { vim.inspect(tbl) } }, true, {})
end

local function make_window(lines)
  local bufnr = vim.api.nvim_create_buf(false, true)
  if bufnr == 0 then
    error("Failed to create nvim buffer")
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":close<CR>", { silent = true })

  vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    row = 3,
    col = 10,
    width = 120,
    height = 30
  })
end

local function extract_from_buf(bufnr, tsnode)
  local srow, scol, erow, ecol = tsnode:range()
  local lines = vim.api.nvim_buf_get_text(bufnr, srow, scol, erow, ecol, {})
  if #lines ~= 1 then
    error("Failed to get parameter, either not found or multi line")
  end
  return lines[1]
end

local function unpack_ts_field(node, field)
  local f = node:field(field)
  if #f ~= 1 then
    error("Unpacked table has len != 1")
  end
  return f[1]
end

local function parse_lua_fn(row, col)
  local node = vim.treesitter.get_node_at_pos(0, row, col, {})
  assert(node ~= nil, "Could not find node for function")
  assert(not node:has_error(), "Not parsing syntax tree, error in it")

  node = node:parent()
  if node:type() ~= "function_declaration" then
    error("Expected to find function_declaration, found " .. node:type())
  end

  local name = extract_from_buf(0, unpack_ts_field(node, "name"))

  local params = unpack_ts_field(node, "parameters")
  local param_names = {}
  for child, child_name in params:iter_children() do
    if child_name ~= nil then
      assert(child_name == "name")
      table.insert(param_names, extract_from_buf(0, child))
    end
  end
  dump(param_names)

  return {
    name = name,
    params = param_names
  }
end

function M.run()
  local name = vim.api.nvim_buf_get_name(0)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1 -- Lines are 0 indexed
  local params = {
    textDocument = {
      uri = string.format("file://%s", name),
    },
    position = {
      line = row,
      character = col,
    },
    context = {
      includeDeclaration = false,
    },
  }
  vim.lsp.buf_request(0, "textDocument/references", params,
    function(err, result, _, _)
      if err ~= nil then
        error(err)
      end

      if result == nil then
        print("Could not find definition")
        return
      end

      local display = {}
      for _, value in pairs(result) do
        local s = value.range.start
        local fmt = string.format("%s %d:%d", value.uri, s.line, s.character)
        table.insert(display, fmt)
      end

      -- TODO parse based on language type
      local info = parse_lua_fn(row, col)
      table.insert(display, info.name)
      for _, x in ipairs(info.params) do
        table.insert(display, x)
      end

      make_window(display)
    end)
end

return M
