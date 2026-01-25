-- null-ls.lua (Updated for none-ls, the maintained fork)

-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

-- for conciseness
local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters

-- to setup format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Helper function to safely add sources
local sources = {}

-- Add formatters (check if they exist before adding)
if formatting.prettier then
	table.insert(sources, formatting.prettier)
end

if formatting.stylua then
	table.insert(sources, formatting.stylua)
end

if formatting.black then
	table.insert(sources, formatting.black.with({
		condition = function(utils)
			return utils.root_has_file("pyproject.toml")
		end,
	}))
end

-- Add diagnostics/linters (check if they exist before adding)
if diagnostics.markdownlint then
	table.insert(sources, diagnostics.markdownlint.with({
		condition = function(utils)
			return utils.root_has_file(".markdownlintrc")
		end,
	}))
end

-- configure null_ls
null_ls.setup({
	sources = sources,

	-- configure format on save
	on_attach = function(current_client, bufnr)
		if current_client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							--  only use null-ls for formatting instead of lsp server
							return client.name == "null-ls"
						end,
						bufnr = bufnr,
					})
				end,
			})
		end
	end,
})
