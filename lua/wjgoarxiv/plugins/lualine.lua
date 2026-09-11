local ok, lualine = pcall(require, "lualine")
if not ok then return end

-- 활성 tokyonight variant(night/day)의 팔레트로 테마를 만든다.
-- tokyonight가 없거나 다른 colorscheme이면 'auto'로 안전 동작.
local function build_theme()
  local style = (vim.g.colors_name or ""):match("^tokyonight%-(%w+)$")
  if not style then return "auto" end

  local ok_hl, base = pcall(function()
    return require("lualine.themes._tokyonight").get(style)
  end)
  local ok_colors, colors = pcall(function()
    return require("tokyonight.colors").setup({ style = style })
  end)
  if not (ok_hl and ok_colors) then return "auto" end

  -- 커스텀 색 유지 (팔레트 키만 사용, hex 하드코딩 없음)
  base.normal.a.bg = colors.blue
  base.insert.a.bg = colors.green
  base.visual.a.bg = colors.magenta
  base.command = {
    a = { gui = "bold", bg = colors.yellow, fg = colors.black },
  }

  return base
end

local function setup()
  lualine.setup({
    options = {
      theme = build_theme(),
      icons_enabled = true,
      globalstatus = true,
      component_separators = { left = "│", right = "│" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "NvimTree", "TelescopePrompt" },
    },
  })
end

setup()

local group = vim.api.nvim_create_augroup("wjgoarxiv_lualine_theme", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", { group = group, pattern = "tokyonight*", callback = setup })
vim.api.nvim_create_autocmd("User", { group = group, pattern = "WjgoarxivThemeChanged", callback = setup })
