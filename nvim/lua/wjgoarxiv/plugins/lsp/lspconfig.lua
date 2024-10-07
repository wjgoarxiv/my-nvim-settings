-- lspconfig.lua

-- Safely require necessary modules
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local keymap = vim.keymap

-- Define the on_attach function to set up keybindings when the LSP attaches to a buffer
local on_attach = function(client, bufnr)
	-- Define keymap options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- General LSP keybindings
	keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- Show definition and references
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- Go to declaration
	keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- Peek definition
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- Go to implementation
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- Code actions
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- Rename symbol
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- Show diagnostics for the current line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- Show diagnostics for the cursor
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- Jump to previous diagnostic
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- Jump to next diagnostic
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- Hover documentation
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- Toggle outline

	-- TypeScript-specific keybindings
	if client.name == "ts_ls" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>", opts) -- Rename file and update imports
		keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>", opts) -- Organize imports
		keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>", opts) -- Remove unused variables
	end
end

-- Enhance LSP capabilities with nvim-cmp for autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

-- -----------------------
-- Language Server Setup
-- -----------------------

-- Function to set up a language server with common settings
local setup_lsp = function(server_name, opts)
	opts = opts or {}
	opts.on_attach = on_attach
	opts.capabilities = capabilities
	lspconfig[server_name].setup(opts)
end

-- Set up various language servers
setup_lsp("html")
setup_lsp("cssls")
setup_lsp("bashls")
setup_lsp("yamlls")
setup_lsp("pyright")
setup_lsp("pylsp")

-- -----------------------
-- TypeScript Language Server Setup
-- -----------------------

-- Ensure that the 'typescript' module is not causing conflicts
-- If you were previously using a TypeScript-specific plugin, it's recommended to remove or disable it
-- to prevent it from setting up 'tsserver' implicitly

-- Set up the new TypeScript language server 'ts_ls'
setup_lsp("ts_ls", {
	-- If 'ts_ls' requires specific settings, add them here
	-- For example, specifying the command to start the server
	-- cmd = { "typescript-language-server", "--stdio" },
	-- settings = { ... },
})