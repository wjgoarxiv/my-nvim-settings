local status, tokyonight = pcall(require, "tokyonight")
if not status then
	print("Tokyonight theme not found!") -- print error if theme not installed
	return
end

tokyonight.setup({
	transparent = true,
	sidebars = { "qf", "help", "NvimTree", "Outline", "terminal" },
	styles = { sidebars = "transparent" },
})

vim.cmd("colorscheme tokyonight-night")