local status, lualine = pcall(require, "lualine")
if not status then
	return
end

local lualine_tokyonight = require("lualine.themes.tokyonight")

local new_colors = {
	blue = "#5E81AC", -- nord10
	green = "#A3BE8C", -- nord14
	violet = "#B48EAD", -- nord15
	yellow = "#EBCB8B", -- nord13
	black = "#3B4252", -- nord1
}

lualine_tokyonight.normal.a.bg = new_colors.blue
lualine_tokyonight.insert.a.bg = new_colors.green
lualine_tokyonight.visual.a.bg = new_colors.violet
lualine_tokyonight.command = {
	a = {
		gui = "bold",
		bg = new_colors.yellow,
		fg = new_colors.black,
	},
}

lualine.setup({
	options = {
		theme = lualine_tokyonight,
	},
})
