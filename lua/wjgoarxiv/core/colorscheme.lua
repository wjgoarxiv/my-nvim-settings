local has_tokyo, tokyonight = pcall(require, "tokyonight")

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

local function apply_tokyonight_variant(background)
	local variant = background == "light" and "tokyonight-day" or "tokyonight-night"
	if safe_colorscheme(variant) then
		return true
	end

	return safe_colorscheme("default")
end

if has_tokyo then
	tokyonight.setup({
		transparent = true,
		sidebars = { "qf", "help", "NvimTree", "Outline", "terminal" },
		styles = { sidebars = "transparent" },
	})
end

local function apply_colorscheme(background)
	if has_tokyo then
		return apply_tokyonight_variant(background)
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
