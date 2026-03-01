local function resolve_path(path)
	return vim.uv.fs_realpath(path) or path
end

local function should_disable_loader(path)
	return #path > 120 or path:find(".sisyphus/worktrees", 1, true) ~= nil
end

local config_path = vim.fn.stdpath("config")
local data_path = vim.fn.stdpath("data")
local resolved_config_path = resolve_path(config_path)
local resolved_data_path = resolve_path(data_path)

if should_disable_loader(resolved_config_path) or should_disable_loader(resolved_data_path) then
	if vim.loader then
		if vim.loader.enable then
			pcall(vim.loader.enable, false)
		end
		vim.loader = nil
	end
end

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
require("wjgoarxiv.plugins.treesitter")

vim.g.copilot_filetypes = { "markdown", "tex", "text", "lua", "python", "bash" }

local clipboard_path = "/mnt/c/Windows/System32/clip.exe"

if vim.fn.executable(clipboard_path) == 1 then
	local wsl_yank = function()
		local event = vim.api.nvim_get_vvar("event")
		local text = table.concat(event.regcontents, "")
		vim.fn.system("echo " .. vim.fn.shellescape(text) .. " | " .. clipboard_path)
	end

	vim.api.nvim_create_augroup("WSLYank", { clear = true })
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = "WSLYank",
		callback = wsl_yank,
	})
end
