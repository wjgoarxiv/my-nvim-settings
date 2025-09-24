-- 1순위: Tokyonight가 설치되어 있으면 그 설정 적용
local has_tokyo, tokyonight = pcall(require, "tokyonight")
if has_tokyo then
  tokyonight.setup({
    transparent = true,
    sidebars = { "qf", "help", "NvimTree", "Outline", "terminal" },
    styles = { sidebars = "transparent" },
  })
  pcall(vim.cmd, "colorscheme tokyonight-night")
  return
end

-- 2순위: GitHub 테마 변형 사용 (플러그인은 이미 설치되어 있음)
local function safe_colorscheme(name, fallback)
  if not pcall(vim.cmd, "colorscheme " .. name) then
    vim.notify(
      "Colorscheme '" .. name .. "' not found. Falling back to '" .. fallback .. "'.",
      vim.log.levels.WARN
    )
    pcall(vim.cmd, "colorscheme " .. fallback)
  end
end

-- github-nvim-theme는 variants를 :colorscheme로 선택합니다.
safe_colorscheme("github_dark_colorblind", "default")
