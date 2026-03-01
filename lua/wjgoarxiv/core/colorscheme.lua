local has_dracula, dracula = pcall(require, "dracula")

local function detect_macos_background()
	if vim.fn.has("macunix") ~= 1 then
		return nil
	end

	local function parse_value(lines)
		if not lines or #lines == 0 then
			return nil
		end

		local value = lines[1]
		if not value then
			return nil
		end

		value = value:lower()
		if value:find("dark", 1, true) or value:find("true", 1, true) then
			return "dark"
		elseif value:find("light", 1, true) or value:find("false", 1, true) then
			return "light"
		end
		return nil
	end

	local ok_osascript, osa_output = pcall(vim.fn.systemlist, [[osascript -e 'tell application "System Events" to get dark mode of appearance preferences']])
	if ok_osascript and vim.v.shell_error == 0 then
		local parsed = parse_value(osa_output)
		if parsed then
			return parsed
		end
	end

	local ok_defaults, defaults_output = pcall(vim.fn.systemlist, { "sh", "-c", "defaults read -g AppleInterfaceStyle 2>&1" })
	if ok_defaults then
		if vim.v.shell_error == 0 then
			local parsed = parse_value(defaults_output)
			if parsed then
				return parsed
			end
		else
			local message = table.concat(defaults_output, " "):lower()
			if message:find("does not exist", 1, true) then
				return "light"
			end
		end
	end

	return nil
end

local function safe_colorscheme(name)
	local ok, err = pcall(vim.cmd, "colorscheme " .. name)
	if not ok then
		vim.notify("Colorscheme '" .. name .. "' not found: " .. err, vim.log.levels.WARN)
	end
	return ok
end

if has_dracula then
	dracula.setup({
		transparent_bg = false,
		italic_comment = true,
	})
end

local function apply_eza_highlights()
	local palette = {
		dir = "#8be9fd",
		exec = "#50fa7b",
		symlink = "#f1fa8c",
		archive = "#ffb86c",
		hidden = "#6272a4",
		accent = "#ff79c6",
	}

	vim.api.nvim_set_hl(0, "Directory", { fg = palette.dir, bold = true })
	vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = palette.dir, bold = true })
	vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = palette.dir, bold = true })
	vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = palette.hidden })
	vim.api.nvim_set_hl(0, "NvimTreeExecFile", { fg = palette.exec, bold = true })
	vim.api.nvim_set_hl(0, "NvimTreeSymlink", { fg = palette.symlink, italic = true })
	vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = palette.accent, bold = true })
	vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = palette.dir, bold = true })
	vim.api.nvim_set_hl(0, "@string.special.path", { fg = palette.archive })
end

local function apply_colorscheme(background)
	if has_dracula then
		if safe_colorscheme("dracula") then
			apply_eza_highlights()
			return true
		end
	end
	return safe_colorscheme("default")
end

local detected_background = detect_macos_background()
vim.g.wjgoarxiv_detected_background = detected_background or ""

if detected_background and detected_background ~= vim.o.background then
	vim.o.background = detected_background
end

local applied = apply_colorscheme(vim.o.background)
vim.g.wjgoarxiv_colorscheme_applied = applied
if not applied then
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			apply_colorscheme(detected_background or vim.o.background)
		end,
	})
end

local colorscheme_group = vim.api.nvim_create_augroup("wjgoarxiv_colorscheme", { clear = true })
vim.api.nvim_create_autocmd("OptionSet", {
	group = colorscheme_group,
	pattern = "background",
	callback = function()
		apply_colorscheme(vim.o.background)
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	group = colorscheme_group,
	pattern = "*",
	callback = apply_eza_highlights,
})
