require("nvim-lightbulb").setup({
  -- Priority of the lightbulb for all handlers except float.
  priority = 10,

  -- We want to not display all the refactor ones, since those are things like 
  -- changing qualifiers, and in rust they will be on every linee
  -- Example: { "quickfix", "refactor.rewrite" }
  -- See: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#codeActionKind
  action_kinds = { "quickfix" },

  -- Whether or not to hide the lightbulb when the buffer is not focused.
  -- Only works if configured during NvimLightbulb.setup
  hide_in_unfocused_buffer = true,
  -- This is the default, disable it
  sign = { enabled = false },
  virtual_text = {
    enabled = true,
    -- Text to show in the virt_text.
    text = "💡",
    -- Position of virtual text given to |nvim_buf_set_extmark|.
    -- Can be a number representing a fixed column (see `virt_text_pos`).
    -- Can be a string representing a position (see `virt_text_win_col`).
    pos = "eol",
    -- Highlight group to highlight the virtual text.
    hl = "LightBulbVirtualText",
    -- How to combine other highlights with text highlight.
    -- See `hl_mode` of |nvim_buf_set_extmark|.
    hl_mode = "combine",
  },
  autocmd = { enabled = true },
})
