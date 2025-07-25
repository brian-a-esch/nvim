local blink = require('blink.cmp')

blink.setup(
---@module 'blink.cmp'
---@type blink.cmp.Config
  {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = 'enter' },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    signature = { enabled = true },

    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      documentation = {
        auto_show = false
      },
      ghost_text = {
        enabled = true
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = {
        'lsp',
        'path',
        'snippets',
        'buffer',
        'ripgrep',
      },
      providers = {
        lsp = {
          -- Only show buffer or ripgrep completions if the lsp has nothing to say
          fallbacks = {
            'ripgrep',
            'buffer',
          },
        },
        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          opts = {
            -- For many options, see `rg --help` for an exact description of
            -- the values that ripgrep expects.
            prefix_min_len = 3,
            context_size = 5,
            max_filesize = "1M",
            project_root_marker = ".git",
            -- Enable fallback to neovim cwd if project_root_marker is not
            -- found. Default: `true`, which means to use the cwd.
            project_root_fallback = true,
            search_casing = "--ignore-case",
            additional_rg_options = {
              -- Ignore *.min.js files
							glob = '!*.min.js',
            },
            -- Show debug information in `:messages` that can help in
            -- diagnosing issues with the plugin.
            debug = false,
          },
          -- (optional) customize how the results are displayed. Many options
          -- are available - make sure your lua LSP is set up so you get
          -- autocompletion help
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              -- example: append a description to easily distinguish rg results
              item.labelDetails = {
                description = "(rg)",
              }
            end
            return items
          end,
        },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" }
  }
)
