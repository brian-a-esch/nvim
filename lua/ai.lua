local codecompanion = require("codecompanion")
local adapters = require("codecompanion.adapters")

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
})
