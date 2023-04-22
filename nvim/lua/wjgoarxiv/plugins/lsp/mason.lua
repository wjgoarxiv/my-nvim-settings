local mason_status, mason = pcall(require, "mason")
if not mason_status then
	return
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

-- import mason-null-ls plugin safely
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	return
end

mason.setup()

mason_lspconfig.setup({
	ensure_installed = {
		"bashls",
		"grammarly",
		"ltex",
		"marksman",
		"pyright",
		"pylsp",
		"yamlls",
	},
	-- auto-install configured servers (with lspconfig)
	automatic_installation = true,
})

mason_null_ls.setup({
	ensure_installed = {
		"prettier",
		"stylua",
		"eslint_d",
		"markdownlint",
		"shellcheck",
		"black",
	},
	-- auto-install configured servers (with null-ls)
	automatic_installation = true,
})
