local telescope = require('telescope')

telescope.setup{
  defaults = {
    prompt_prefix = " ",
    layout_config = {
      prompt_position = "top",
      preview_width = 0.65,
    },
    sorting_strategy = "ascending",
  },
}
