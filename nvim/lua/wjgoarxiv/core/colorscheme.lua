-- Use VSCode theme for Neovim

local status, tokyonight = pcall(require, "tokyonight")
if not status then
	print("Tokyonight theme not found!")
	return
end

-- for the vscode theme setup
-- vscode.setup({
--	transparent = true,
--	italic_comments = true,
--	disable_nvimtree_bg = true,
--	styles = { sidebars = "transparent" },
--})
--

-- for the tokyonight theme
tokyonight.setup({
	transparent = true,
	sidebars = { "qf", "help", "NvimTree", "Outline", "terminal" },
	styles = { sidebars = "transparent" },
})

vim.cmd("colorscheme tokyonight-night")
