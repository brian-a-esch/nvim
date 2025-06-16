local codecompanion = require("codecompanion")
local adapters = require("codecompanion.adapters")
local diff = require('mini.diff')
local markdown = require('render-markdown')
local avante = require('avante')

markdown.setup({
  file_types = { 'markdown', 'codecompanion' }
})

diff.setup({
  source = diff.gen_source.none()
})

codecompanion.setup({
  strategies = {
    chat = {
      adapter = 'azure_openai'
    },
    inline = {
      adapter = 'azure_openai'
    },
  },
  adapters = {
    openai = function()
      return require("codecompanion.adapters").extend("openai", {
        env = {
          api_key = "cmd: gpg --batch --quiet --decrypt " .. vim.fs.normalize("~/.openai.key.gpg"),
        },
      })
    end,
    azure_openai = function()
      return adapters.extend("azure_openai", {
        env = {
          api_key = "cmd: cat " .. vim.fs.normalize("~/.azure_ai.key"),
          endpoint = 'https://azure-openai.drwcloud.com/',
        },
        schema = {
          model = {
            default = 'gpt-4o',
          },
        },
      })
    end,
  },
  display = {
    diff = {
      provider = 'mini_diff'
    },
  },
})

local function load_file_to_string(path)
  local file = io.open(path, 'r')
  if file == nil then
    error("Failed to open file " .. path)
  end

  local content = file:read("l")
  file:close()
  return content
end
-- Until https://github.com/yetone/avante.nvim/issues/2097 is resolved, possibly with 
-- this PR https://github.com/yetone/avante.nvim/pull/2098/files  it seems like we're going to have 
-- to set the OPENAI_API_KEY environment variable
vim.env.OPENAI_API_KEY = load_file_to_string(vim.fs.normalize('~/.azure_ai.key'))

avante.setup({
  --debug = true,
  ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  provider = "azure",
  ---@alias Mode "agentic" | "legacy"
  mode = "agentic", -- The default mode for interaction. "agentic" uses tools to automatically generate code, "legacy" uses the old planning method to generate code.
  -- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
  -- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
  -- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
  auto_suggestions_provider = "azure",
  providers = {
    azure = {
      endpoint = "https://azure-openai.drwcloud.com/",
      --api_key_name = 'cmd: cat ' .. vim.fs.normalize("~/.azure_ai.key"),
      model = "gpt-4o",
      -- This needs to be kept in sync with the model to form requests like
      -- https://azure-openai.drwcloud.com/openai/deployments/gpt-4o-mini/chat/completions?api-version=2024-02-15-preview
      deployment = "gpt-4o", -- This needs to be kept in sync with the model
      api_version = "2025-01-01-preview",
      extra_request_body = {
        max_completion_tokens = 4096,
      },
    },
  },
  behaviour = {
    auto_suggestions = false, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
    minimize_diff = true,                  -- Whether to remove unchanged lines when applying a code block
    enable_token_counting = true,          -- Whether to enable token counting. Default to true.
    auto_approve_tool_permissions = false, -- Default: show permission prompts for all tools
    -- Examples:
    -- auto_approve_tool_permissions = true,                -- Auto-approve all tools (no prompts)
    -- auto_approve_tool_permissions = {"bash", "replace_in_file"}, -- Auto-approve specific tools only
  },
  mappings = {
    --- @class AvanteConflictMappings
    diff = {
      ours = "co",
      theirs = "ct",
      all_theirs = "ca",
      both = "cb",
      cursor = "cc",
      next = "]x",
      prev = "[x",
    },
    suggestion = {
      accept = "<M-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
    jump = {
      next = "]a",
      prev = "[a",
    },
    submit = {
      normal = "<CR>",
      insert = "<C-s>",
    },
    cancel = {
      normal = { "<C-c>", "<Esc>", "q" },
      insert = { "<C-c>" },
    },
    sidebar = {
      apply_all = "A",
      apply_cursor = "a",
      retry_user_request = "R",
      edit_user_request = "e",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
      remove_file = "d",
      add_file = "@",
      close = { "<Esc>", "q" },
      close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
    },
  },
  hints = { enabled = true },
  windows = {
    ---@type "right" | "left" | "top" | "bottom"
    position = "right", -- the position of the sidebar
    wrap = true,        -- similar to vim.o.wrap
    width = 30,         -- default % based on available width
    sidebar_header = {
      enabled = true,   -- true, false to enable/disable the header
      align = "center", -- left, center, right for title
      rounded = true,
    },
    input = {
      prefix = "> ",
      height = 8, -- Height of the input window in vertical layout
    },
    edit = {
      border = "rounded",
      start_insert = true, -- Start insert mode when opening the edit window
    },
    ask = {
      floating = false,    -- Open the 'AvanteAsk' prompt in a floating window
      start_insert = true, -- Start insert mode when opening the ask window
      border = "rounded",
      ---@type "ours" | "theirs"
      focus_on_apply = "ours", -- which diff to focus after applying
    },
  },
  highlights = {
    diff = {
      current = "DiffText",
      incoming = "DiffAdd",
    },
  },
  --- @class AvanteConflictUserConfig
  diff = {
    autojump = true,
    ---@type string | fun(): any
    list_opener = "copen",
    --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
    --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
    --- Disable by setting to -1.
    override_timeoutlen = 500,
  },
  suggestion = {
    debounce = 600,
    throttle = 600,
  },
  file_selector = {
    provider = 'telescope',
  },
})
