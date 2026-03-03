-- Skip in headless / non-terminal environments
if #vim.api.nvim_list_uis() == 0 then
  return
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
