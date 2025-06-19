local codecompanion = require("codecompanion")
local adapters = require("codecompanion.adapters")
local diff = require('mini.diff')
local markdown = require('render-markdown')

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
      return adapters.extend("openai", {
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
          api_version = '2025-01-01-preview',
          deployment = "gpt-4.1",
        },
        schema = {
          model = {
            default = 'gpt-4.1',
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
      close_chat_at = 240,     -- Close an open chat buffer if the total columns of your display are less than...
      layout = "vertical",     -- vertical|horizontal split for default provider
      opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
    },
  },
  opts = {
    --log_level = "TRACE"
  },
})

vim.keymap.set({ "n", "v" }, "<C-a>", ":CodeCompanion #buffer ", { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
