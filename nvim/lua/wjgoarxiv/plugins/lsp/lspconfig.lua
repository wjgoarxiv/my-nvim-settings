-- lspconfig.lua (Updated for Neovim 0.11+)

-- Safely require cmp_nvim_lsp for autocompletion capabilities
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
	keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts) -- Show definition and references
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
	keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts) -- Toggle outline

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
-- Language Server Setup (Neovim 0.11+ API)
-- -----------------------

-- Common configuration for all LSP servers
local common_config = {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- List of language servers to enable
local servers = {
	"html",
	"cssls",
	"bashls",
	"yamlls",
	"pyright",
	"pylsp",
	"ts_ls",
}

-- Configure each server using the new vim.lsp.config API
for _, server in ipairs(servers) do
	vim.lsp.config(server, common_config)
end

-- Enable all configured servers
vim.lsp.enable(servers)
