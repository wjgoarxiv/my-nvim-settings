-- Enable treesitter highlighting and indentation for all supported filetypes
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
