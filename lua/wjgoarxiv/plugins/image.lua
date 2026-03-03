-- Skip in headless / non-terminal environments
if #vim.api.nvim_list_uis() == 0 then
  return
end

-- Ensure ImageMagick is on PATH (Windows choco installs may not propagate to nvim)
if vim.fn.has("win32") == 1 and vim.fn.executable("magick") == 0 then
  local matches = vim.fn.glob("C:\\Program Files\\ImageMagick*", false, true)
  if #matches > 0 then
    vim.env.PATH = matches[#matches] .. ";" .. vim.env.PATH
  end
end

-- Auto-detect terminal backend for image rendering
local function detect_backend()
  if vim.env.KITTY_PID then
    return "kitty"
  elseif vim.env.GHOSTTY_RESOURCES_DIR then
    return "kitty" -- Ghostty implements Kitty graphics protocol
  elseif vim.env.TERM_PROGRAM == "WezTerm" then
    return "kitty"
  elseif vim.env.WT_SESSION then
    return "sixel" -- Windows Terminal supports Sixel since v1.22
  else
    return "kitty" -- default
  end
end

local ok, image = pcall(require, "image")
if not ok then
  return
end

image.setup({
  backend = detect_backend(),
  processor = "magick_cli",
  integrations = {
    markdown = { enabled = true },
  },
})
