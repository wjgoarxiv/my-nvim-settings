print("INFO: init.lua loaded")
require("wjgoarxiv.plugins-setup")
require("wjgoarxiv.core.options")
require("wjgoarxiv.core.keymaps")
require("wjgoarxiv.core.colorscheme")
require("wjgoarxiv.plugins.nvim-tree")
require("wjgoarxiv.plugins.lualine")
require("wjgoarxiv.plugins.telescope")
require("wjgoarxiv.plugins.nvim-cmp")
require("wjgoarxiv.plugins.toggleterm")
require("wjgoarxiv.plugins.lsp.mason")
require("wjgoarxiv.plugins.lsp.lspsaga")
require("wjgoarxiv.plugins.lsp.lspconfig")
require("wjgoarxiv.plugins.lsp.null-ls")

vim.g.copilot_filetypes = { "markdown", "tex", "text", "lua", "python", "bash" }

local clipboard_path = "/mnt/c/Windows/System32/clip.exe"

if vim.fn.executable(clipboard_path) == 1 then
	local wsl_yank = function()
		local event = vim.api.nvim_get_vvar("event")
		local text = table.concat(event.regcontents, "
")
		vim.fn.system("echo " .. vim.fn.shellescape(text) .. " | " .. clipboard_path)
	end

	vim.api.nvim_create_augroup("WSLYank", { clear = true })
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = "WSLYank",
		callback = wsl_yank,
	})
end
