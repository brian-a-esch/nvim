local nvim_tree = require('nvim-tree')
local tree_cb = require('nvim-tree.config').nvim_tree_callback

nvim_tree.setup{
    -- have cursor start at the begining of the file name
    hijack_cursor = true,
    renderer = {
        root_folder_modifier = ":t",
        -- Don't follow symlinks, leads to really wide file tree
        symlink_destination = false,
        icons = {
            glyphs = {
                default = "",
                symlink = "",
                folder = {
                    arrow_open = "",
                    arrow_closed = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "",
                    staged = "S",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "U",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },
    view = {
	-- redraw tree by longest line
	adaptive_size = true,
        width = 30,
        side = "left",
        mappings = {
            list = {
		{ key = { "<CR>", "o" }, cb = tree_cb "edit" },
		{ key = "h", cb = tree_cb "close_node" },
		{ key = "l", cb = tree_cb "open_node" },
		{ key = "v", cb = tree_cb "vsplit" },
		{ key = "H", cb = tree_cb "collapse_all" },
		{ key = "L", cb = tree_cb "expand_all" },
            },
        },
    },
    git = {
      -- Do not ignore git ignored files
      ignore = false,
    }

}
