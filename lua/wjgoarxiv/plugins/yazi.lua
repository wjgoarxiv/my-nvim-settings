local setup, yazi = pcall(require, "yazi")
if not setup then
  return
end

yazi.setup({
  open_for_directories = false, -- nvim-tree handles directories
  keymaps = {
    show_help = "<f1>",
  },
})

-- Keymaps
local keymap = vim.keymap.set
keymap("n", "<leader>-", "<cmd>Yazi<cr>", { desc = "Open yazi (current file)" })
keymap("n", "<leader>cw", "<cmd>Yazi cwd<cr>", { desc = "Open yazi (cwd)" })
keymap("n", "<C-up>", "<cmd>Yazi toggle<cr>", { desc = "Resume last yazi session" })
