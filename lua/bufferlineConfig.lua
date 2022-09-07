require('bufferline').setup{
    options = {
	separator_style = "thin",
	offsets = {
	    {
		filetype = "NvimTree",
		text = "File Explorer",
		highlight = "Directory",
		separator = true, -- use a "true" to enable the default, or set your own character
	    },
	},
    },
}

