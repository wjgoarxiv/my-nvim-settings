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

local is_ghostty = vim.env.GHOSTTY_RESOURCES_DIR ~= nil

image.setup({
  backend = detect_backend(),
  processor = "magick_cli",
  integrations = {
    markdown = { enabled = true },
  },
  window_overlap_clear_enabled = true,
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
})

-- Ghostty workaround: send raw Kitty graphics delete-all escape sequence
-- directly to stdout on BufLeave from image buffers, bypassing image.nvim's
-- internal clearing which relies on delete-by-id (d=i) that Ghostty mishandles.
-- See: https://github.com/ghostty-org/ghostty/issues/6711
if is_ghostty then
  vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
    callback = function()
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname:match("%.png$")
        or bufname:match("%.jpg$")
        or bufname:match("%.jpeg$")
        or bufname:match("%.gif$")
        or bufname:match("%.webp$")
        or bufname:match("%.avif$")
      then
        -- Send raw Kitty graphics protocol: action=delete, delete=all, quiet=2
        io.stdout:write("\x1b_Ga=d,d=a,q=2\x1b\\")
        io.stdout:flush()
      end
    end,
  })
end
