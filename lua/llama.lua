local log = require('log')

-- llama_cmp.lua - Lua port of llama.vim for FIM-style inline completion
local llama = {}

-- Configuration defaults
llama.config = {
  endpoint = "http://localhost:8012/infill",
  model = "llama",
  max_tokens = 64,
  temperature = 0.2,
  top_p = 0.95,
  n = 1,
  cache_size = 100,
  ring_line_count = 30,
  keymap_accept = "<Tab>",
  n_local_ctx = 20,
}

-- Internal state
local ring_data = {}
local current_buf = nil
local current_ns = vim.api.nvim_create_namespace("llama_cmp")
local pending = false

-- Util: truncate text
local function truncate(text, max)
  if #text > max then
    return text:sub(#text - max + 1)
  end
  return text
end

function llama.request_completion(cursor_line, prefix, suffix, callback)
  local input = {
    input_prefix = prefix,
    input_suffix = suffix,
    prompt = cursor_line,
    model = llama.config.model,
    max_tokens = llama.config.max_tokens,
    temperature = llama.config.temperature,
    top_p = llama.config.top_p,
    n = llama.config.n,
    stop = { "<|endoftext|>" },
  }
  log:info("Making a request with")

  local body = vim.json.encode(input)

  local on_exit = function(obj)
    local res = vim.json.decode(obj.stdout)
		res = cursor_line .. res.content
    log:info("Got a completion result %s", res)
    callback(res)
  end

  vim.system({
    "curl",
    "-s",
    "-X",
    "POST",
    llama.config.endpoint,
    "-H",
    "Content-Type: application/json",
    "-d",
    body
  }, { text = true }, on_exit)
end

-- Capture context and trigger inline completion
function llama.fim_inline(callback)
  if pending then
    log:info("Skipping completion because we're pending")
    callback()
    return
  end
  pending = true

  log:debug("We're in inline")
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local prefix = vim.api.nvim_buf_get_lines(bufnr, row - llama.config.n_local_ctx, row - 1, false)
  -- We replace the end of the first line of the suffix
  local suffix = vim.api.nvim_buf_get_lines(bufnr, row, row + llama.config.n_local_ctx, false)

  local cur_line = vim.api.nvim_get_current_line()
  -- We used to split the line, but now we don't need to do that?
  --local pre_cursor = cur_line:sub(1, col)
  --local post_cursor = cur_line:sub(col + 1)
  --table.insert(prefix, pre_cursor)
  --suffix[1] = post_cursor .. (suffix[1] or "")

  local joined_prefix = table.concat(prefix, "\n")
  local joined_suffix = table.concat(suffix, "\n")

  llama.request_completion(cur_line, joined_prefix, joined_suffix, function(text)
    pending = false
    callback(text)
  end)
end

function llama.setup(opts)
  llama.config = vim.tbl_extend("force", llama.config, opts or {})
end

-- TODO actually make this configurable
llama.setup({})

return llama
