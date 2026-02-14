-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Lazy wants us to set leader and other options before calling setup
require 'options'
require 'keymaps'
require("lazy").setup("plugins")
require 'colorscheme'
require 'lsp'
require 'diffviewConfig'
require 'nvim-treeConfig'
require 'treesitterConfig'
require 'telescopeConfig'
require 'toggletermConfig'
require 'virt-columnConfig'
require 'gitsignsConfig'
require 'fidgetConfig'
require 'autopairsConfig'
require 'illuminateConfig'
require 'dapConfig'
require 'orgmodeConfig'
require 'refactor'
require 'homescreen'
require 'codeActions'
require 'completion'
require 'ai'

function DUMP(tbl)
  vim.api.nvim_echo({ { vim.inspect(tbl) } }, true, {})
end
