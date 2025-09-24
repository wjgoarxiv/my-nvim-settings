local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

configs.setup({
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "c",
    "bash",
    "python",
    "tsx",
    "typescript",
    "json",
    "yaml",
  },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true, disable = { "markdown" } },
})

-- Ensure markdown buffers have the proper highlighter active
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "markdown.mdx" },
  callback = function(args)
    pcall(vim.treesitter.start, args.buf, "markdown")
    pcall(vim.treesitter.start, args.buf, "markdown_inline")
  end,
})
