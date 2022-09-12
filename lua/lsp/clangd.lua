-- Language server stuff, should pull into separate files
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	-- This is what it is in clion, maybe change?
	vim.keymap.set('i', '<C-p>', vim.lsp.buf.signature_help, bufopts)
	-- These are workspace commands. Typically  I just start neovim in a project directory
	-- so these are not needed to manually configure the lsp
	--vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	--vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	--vim.keymap.set('n', '<space>wl', function()
		--print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	--end, bufopts)
	vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', 'gc', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, bufopts)
	-- Using telescope for this 
	--vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	
	vim.keymap.set('n', 'gQ', vim.lsp.buf.formatting, bufopts)
	-- range_formatting selects from last visual selection. Hence the escape at the beginning
	vim.keymap.set('v', 'gq', '<ESC><cmd>lua vim.lsp.buf.range_formatting()<CR>', bufopts)
end

require('lspconfig')['clangd'].setup{
	on_attach = on_attach,
	cmd = {
		"clangd",
		"--background-index",
	},
}
