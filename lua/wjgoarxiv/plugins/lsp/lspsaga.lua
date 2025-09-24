-- import lspsaga safely
local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
  return
end

saga.setup({
  ui = {
    border = "rounded",
    colors = {
      normal_bg = "#022746",
    },
  },
  scroll_preview = {
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  definition = {
    keys = {
      edit = "<CR>",
    },
  },
  outline = {
    win_position = "right",
    layout = "float",
  },
  lightbulb = {
    enable = false,
    sign = false,
  },
})
