-- Use VSCode theme for Neovim

local status, vscode = pcall(require, "vscode")
if not status then
	print("VSCode theme not found!")
	return
end

vscode.setup({
	transparent = true,
	italic_comments = true,
	disable_nvimtree_bg = true,
	styles = { sidebars = "transparent" },
})

vim.cmd("colorscheme vscode")
