local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
  "                                                     ",
  "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  "                                                     ",
}

-- Set menu
dashboard.section.buttons.val = {
  dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
  dashboard.button("g", "  > RipGrep", ":Telescope live_grep<CR>"),
  -- Thse take advantage of the fact that the first buffer will be bufnr 1, and delete it
  dashboard.button("s", "  > Git Status", ":vert G | bd 1 <CR>"),
  dashboard.button("l", "  > Git Log", ":vert G log --stat --decorate -200 | bd 1 <CR>"),
  dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
  dashboard.button("c", "  > Config", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
  dashboard.button("o", "  > Open Orgmode notes", ":e " .. DEFAULT_ORG_FILE .. "<CR>"),
  dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
}

alpha.setup(dashboard.opts)
