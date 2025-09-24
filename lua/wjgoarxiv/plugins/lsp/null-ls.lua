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

-- configure null_ls
local sources = {
	--  to disable file types use
	--  "formatting.prettier.with({disabled_filetypes = {}})" (see null-ls docs)
	formatting.prettier, -- js/ts formatter
	formatting.stylua, -- lua formatter
	formatting.black.with({ -- python formatter
		-- only enable black if root has pyproject.toml (not in youtube nvim video)
		condition = function(utils)
			return utils.root_has_file("pyproject.toml")
		end,
	}),
}

-- use eslint/markdownlint/shellcheck only when provided by none-ls install
local eslint
do
	local eslint_ok, eslint_builtin = pcall(require, "none-ls.diagnostics.eslint")
	if eslint_ok then
		eslint = eslint_builtin
	end
end
if eslint then
	sources[#sources + 1] = eslint.with({ -- js/ts linter
		-- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
		condition = function(utils)
			return utils.root_has_file(".eslintrc.js") -- change file extension if you use something else
		end,
	})
end

local markdownlint = diagnostics.markdownlint or diagnostics.markdownlint_cli2
if markdownlint then
	sources[#sources + 1] = markdownlint.with({ -- markdown linter
		-- only enable markdownlint if root has .markdownlintrc (not in youtube nvim video)
		condition = function(utils)
			return utils.root_has_file(".markdownlintrc")
		end,
	})
end

local shellcheck
do
	local ok_shellcheck, shellcheck_builtin = pcall(require, "none-ls.diagnostics.shellcheck")
	if ok_shellcheck then
		shellcheck = shellcheck_builtin
	end
end
if shellcheck then
	sources[#sources + 1] = shellcheck.with({ -- shell linter
		-- only enable shellcheck if root has .shellcheckrc (not in youtube nvim video)
		condition = function(utils)
			return utils.root_has_file(".shellcheckrc")
		end,
	})
end

null_ls.setup({
	-- setup formatters & linters
	sources = sources,

	-- configure format on save
	on_attach = function(current_client, bufnr)
		if current_client.supports_method ~= nil and current_client:supports_method("textDocument/formatting") then
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
