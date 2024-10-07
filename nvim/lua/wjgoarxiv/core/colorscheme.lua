-- colorscheme.lua

-- Attempt to load the GitHub Theme
local status, github_theme = pcall(require, "github-theme")
if not status then
	print("GitHub Theme not found!")
	return
end

-- Configure GitHub Theme
github_theme.setup({
	options = {
		transparent = true, -- Maintain transparency if desired
		hide_nc_statusline = false,
		hide_background = false,
		darken = {
			sidebars = {
				enable = true, -- Enable darkening for sidebars
				list = { "qf", "vista_kind", "terminal", "packer", "NvimTree", "help", "Outline" }, -- Updated sidebar list
			},
		},
		-- Additional options can be added here as needed
	},
	-- Remove the deprecated 'theme_style' option
	-- You can select the desired theme variant using the :colorscheme command below
})

-- Apply the desired GitHub Theme variant
-- Available options include:
-- "github_dark", "github_dark_high_contrast", "github_dark_colorblind",
-- "github_light", "github_light_high_contrast", "github_light_colorblind"
vim.cmd("colorscheme github_light") -- Choose your preferred variant