require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = 'openai'
    },
    inline = {
      adapter = 'openai'
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
  },
})
