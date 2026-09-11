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

	-- `defaults` reflects the persisted appearance setting and is consulted first;
	-- `osascript` is only a fallback because it can report a stale value.
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

	local ok_osascript, osa_output = pcall(vim.fn.systemlist, [[osascript -e 'tell application "System Events" to get dark mode of appearance preferences']])
	if ok_osascript and vim.v.shell_error == 0 then
		local parsed = parse_value(osa_output)
		if parsed then
			return parsed
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

if has_tokyo then
	tokyonight.setup({
		transparent = false,
		sidebars = { "qf", "help", "NvimTree", "Outline", "terminal" },
		styles = { sidebars = "", floats = "" },
	})
end

-- User preference: "light" | "dark" | "auto", persisted outside the repo.
local preference_path = vim.fs.joinpath(vim.fn.stdpath("state"), "wjgoarxiv-theme")
local valid_modes = { light = true, dark = true, auto = true }

local function read_preference()
	local ok, lines = pcall(vim.fn.readfile, preference_path)
	if not ok or not lines or #lines == 0 then
		return "auto"
	end
	local mode = vim.trim(lines[1] or ""):lower()
	if valid_modes[mode] then
		return mode
	end
	return "auto"
end

local function write_preference(mode)
	pcall(vim.fn.mkdir, vim.fs.dirname(preference_path), "p")
	local ok = pcall(vim.fn.writefile, { mode }, preference_path)
	if not ok then
		vim.notify("Could not save theme preference to " .. preference_path, vim.log.levels.WARN)
	end
end

local function apply_tokyonight_variant(background)
	local variant = background == "light" and "tokyonight-day" or "tokyonight-night"
	if safe_colorscheme(variant) then
		return true
	end

	return safe_colorscheme("default")
end

local function apply_colorscheme(background)
	if has_tokyo then
		return apply_tokyonight_variant(background)
	end
	return safe_colorscheme("default")
end

local preference = read_preference()
vim.g.wjgoarxiv_theme_preference = preference

local detected_background = nil
if preference == "auto" then
	detected_background = detect_macos_background()
end
vim.g.wjgoarxiv_detected_background = detected_background or ""

local target_background = preference ~= "auto" and preference or detected_background

if target_background and target_background ~= vim.o.background then
	vim.o.background = target_background
end

local applied = apply_colorscheme(vim.o.background)
vim.g.wjgoarxiv_colorscheme_applied = applied
if not applied then
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			apply_colorscheme(target_background or vim.o.background)
		end,
	})
end

local colorscheme_group = vim.api.nvim_create_augroup("wjgoarxiv_colorscheme", { clear = true })
vim.api.nvim_create_autocmd("OptionSet", {
	group = colorscheme_group,
	pattern = "background",
	nested = true, -- let the resulting ColorScheme event reach lualine
	callback = function()
		-- An explicit preference wins over anything else that flips 'background'.
		if preference ~= "auto" and vim.o.background ~= preference then
			vim.o.background = preference
		end
		apply_colorscheme(vim.o.background)
	end,
})

local function set_theme(mode)
	if not valid_modes[mode] then
		vim.notify("Theme: expected light, dark or auto (got '" .. tostring(mode) .. "')", vim.log.levels.WARN)
		return
	end

	preference = mode
	vim.g.wjgoarxiv_theme_preference = mode
	write_preference(mode)

	local background = mode
	if mode == "auto" then
		detected_background = detect_macos_background()
		vim.g.wjgoarxiv_detected_background = detected_background or ""
		background = detected_background or vim.o.background
	end

	if background ~= vim.o.background then
		vim.o.background = background
	end
	apply_colorscheme(background)
	vim.api.nvim_exec_autocmds("User", { pattern = "WjgoarxivThemeChanged", modeline = false })
end

vim.api.nvim_create_user_command("Theme", function(opts)
	set_theme(vim.trim(opts.args):lower())
end, {
	nargs = 1,
	complete = function()
		return { "light", "dark", "auto" }
	end,
	desc = "Set colorscheme preference: light | dark | auto",
})
