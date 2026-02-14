local codecompanion = require("codecompanion")
local adapters = require("codecompanion.adapters")
local diff = require('mini.diff')
local markdown = require('render-markdown')

markdown.setup({
  file_types = { 'markdown', 'codecompanion' }
})

diff.setup({
  source = diff.gen_source.none(),
  -- Delays (in ms) defining asynchronous processes
  delay = {
    -- How much to wait before update following every text change
    text_change = 100,
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Apply hunks inside a visual/operator region
    apply = '',
    -- Reset hunks inside a visual/operator region
    reset = '',
    -- Hunk range textobject to be used inside operator
    -- Works also in Visual mode if mapping differs from apply and reset
    textobject = '',
    -- Go to hunk range in corresponding direction
    goto_first = '[H',
    goto_prev = '[h',
    goto_next = ']h',
    goto_last = ']H',
  },
  options = {
    -- wraps the "goto" commands around
    wrap_goto = true,
  }
})

local AGENTS_FILES = {}

local function find_agents(path)
  local base_agent = vim.fs.joinpath(path, "AGENTS.md")
  -- If there is no agent file in directory we've loaded, then don't search for agent files
  if not vim.uv.fs_stat(base_agent) then
    return
  end

  local function scan(dir)
    local fd = vim.uv.fs_scandir(dir)
    if not fd then return end
    while true do
      local name, typ = vim.uv.fs_scandir_next(fd)
      if not name then break end
      local full_path = dir .. "/" .. name
      if typ == "directory" then
        scan(full_path)
      elseif typ == "file" and name == "AGENTS.md" then
        table.insert(AGENTS_FILES, full_path)
      end
    end
  end
  scan(path)
end

find_agents(vim.fn.getcwd())


-- Used for loading prompts which I like to store as markdown
local function load_file_to_string(orig_path)
  local path = vim.fs.normalize(orig_path)
  local file = io.open(path, 'r')
  if file == nil then
    error("Failed to open file " .. path)
  end

  local content = file:read("a")
  file:close()
  return content
end

PROMPTS_DIR = '~/.config/nvim/prompts/'

codecompanion.setup({
  strategies = {
    chat = {
      adapter = 'azure_openai',
      tools = {
        opts = {
          wait_timeout = 10 * 60 * 1000, -- wait_timeout is in ms, default is 30s which is not enough to review changes IMO
          default_tools = {
            'files',
            'cmd_runner',
            'grep_search',
          },
        },
        groups = {
          ["files"] = {
            opts = {
              collapse_tools = false,
            }
          }
        },
      },
    },
    inline = {
      adapter = 'azure_openai',
    },
  },
  adapters = {
    openai = function()
      return adapters.extend("openai", {
        env = {
          api_key = "cmd: cat " .. vim.fs.normalize("~/.openai.key"),
        },
        schema = {
          model = {
            default = "gpt-5",
          },
        },
      })
    end,
    azure_openai = function()
      return adapters.extend("azure_openai", {
        env = {
          api_key = "cmd: cat " .. vim.fs.normalize("~/.azure_ai.key"),
          endpoint = 'https://drw-azureai.drwcloud.com/',
          api_version = '2025-01-01-preview',
          deployment = "gpt-5",
        },
        schema = {
          model = {
            default = 'gpt-5',
          },
        },
      })
    end,
  },
  display = {
    chat = {
      show_settings = true,
    },
    diff = {
      provider = 'mini_diff',
      enabled = true,
      close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
      layout = "horizontal", -- vertical|horizontal split for default provider
      opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
    },
  },
  prompt_library = {
    ["Generate PRD"] = {
      strategy = "chat",
      description = "Prompt to help create a Project Requirements Document",
      prompts = {
        {
          role = "system",
          content = load_file_to_string(PROMPTS_DIR .. "create-prd.md")
        },
        {
          role = "user",
          content = 'Please generate a PRD to ',
        }
      },
      opts = {
        is_slash_cmd = true,
        short_name = "generate-prd",
        ignore_system_prompt = true,
      },
    },
    -- TODO it'd be good to add something where we can force ourselves to link the PRD when we run this, then autosubmit
    ["Generate Tasks from PRD"] = {
      strategy = "chat",
      description = "Prompt to help create a list of tasks from a Project Requirements Document",
      prompts = {
        {
          role = "system",
          content = load_file_to_string(PROMPTS_DIR .. "generate-tasks-from-prd.md")
        },
        {
          role = "user",
          content = 'Please generate tasks from the  ',
        }
      },
      opts = {
        is_slash_cmd = true,
        short_name = "generate-tasks",
        ignore_system_prompt = true,
      },
    },
    -- TODO it'd be good to add something where we can force ourselves to link the PRD & task list when we run this, then autosubmit
    ["Execute Tasks from List"] = {
      strategy = "chat",
      description = "Prompt to help create a list of tasks from a Project Requirements Document",
      prompts = {
        {
          role = "system",
          content = load_file_to_string(PROMPTS_DIR .. "execute-task-list.md")
        },
        {
          role = "user",
          content = 'Execute tasks by rules lined out in Task List Management',
        }
      },
      opts = {
        is_slash_cmd = true,
        short_name = "execute-task-list",
        auto_submit = true,
      },
    },
    ["Agents MD Files"] = {
      strategy = "chat",
      description = "Adds the AGENTS.md files from the working directory and sub-directories",
      opts = {
        is_slash_cmd = true,
        short_name = "agents-md",
      },
      references = {
        {
          type = "file",
          path = AGENTS_FILES,
        },
      },
    },
  },
  opts = {
    --log_level = "TRACE"
  },
})

vim.keymap.set({ "n", "v" }, "<leader>a", function ()
  codecompanion.toggle()
  vim.cmd('wincmd =')
end, { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
