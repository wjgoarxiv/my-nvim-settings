local ok, lualine = pcall(require, "lualine")
if not ok then return end

-- 기본값은 'auto' (현재 colorscheme에 맞춰 안전 동작)
local theme = "auto"

local ok_theme, base = pcall(require, "lualine.themes.dracula")
if ok_theme then
  local new_colors = {
    blue   = "#8be9fd",
    green  = "#50fa7b",
    violet = "#ff79c6",
    yellow = "#f1fa8c",
    black  = "#282a36",
  }

  -- 커스텀 색 유지
  base.normal.a.bg = new_colors.blue
  base.insert.a.bg = new_colors.green
  base.visual.a.bg = new_colors.violet
  base.command = {
    a = { gui = "bold", bg = new_colors.yellow, fg = new_colors.black },
  }

  theme = base
end

lualine.setup({
  options = {
    theme = theme,         
    icons_enabled = true,
    globalstatus = true,
    component_separators = { left = "│", right = "│" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "NvimTree", "TelescopePrompt" },
  },
})
