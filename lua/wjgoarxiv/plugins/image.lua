-- Skip in headless / non-terminal environments
if #vim.api.nvim_list_uis() == 0 then
  return
end

local ok, snacks = pcall(require, "snacks")
if not ok then
  return
end

snacks.setup({
  image = {
    enabled = true,
    doc = { enabled = true },
  },
})
