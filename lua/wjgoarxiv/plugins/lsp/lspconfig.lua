-- lspconfig.lua (Neovim 0.10+ compatible configuration)

if not vim.lsp or not vim.lsp.config then
  return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  return
end

local typescript_tools_status, typescript_tools = pcall(require, "typescript-tools")
local ts_api = nil
if typescript_tools_status then
  local ok, api = pcall(require, "typescript-tools.api")
  if ok then
    ts_api = api
  end
end

local keymap = vim.keymap

-- Define the on_attach function to set up keybindings when the LSP attaches to a buffer
local function on_attach(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- General LSP keybindings
  keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts) -- Show definition and references
  keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- Peek definition
  keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
  keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
  keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
  keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
  keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
  keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
  keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
  keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts)

  if client.name == "typescript-tools" and ts_api then
    keymap.set("n", "<leader>rf", ts_api.rename_file, opts)
    keymap.set("n", "<leader>oi", ts_api.organize_imports, opts)
    keymap.set("n", "<leader>ru", ts_api.remove_unused_imports, opts)
  end
end

local capabilities = cmp_nvim_lsp.default_capabilities()

local function merge_on_attach(existing)
  if not existing then
    return on_attach
  end

  return function(client, bufnr)
    on_attach(client, bufnr)
    existing(client, bufnr)
  end
end

local function setup_lsp(name, opts)
  opts = opts or {}
  opts.capabilities = capabilities
  opts.on_attach = merge_on_attach(opts.on_attach)

  local ok = pcall(vim.lsp.config, name, opts)
  if not ok then
    return
  end
  pcall(vim.lsp.enable, name)
end

setup_lsp("bashls")
setup_lsp("cssls")
setup_lsp("grammarly")
setup_lsp("html")
setup_lsp("ltex")
setup_lsp("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})
setup_lsp("marksman")
setup_lsp("pyright")
setup_lsp("pylsp")
setup_lsp("yamlls")

if typescript_tools_status then
  typescript_tools.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      separate_diagnostic_server = true,
      publish_diagnostic_on = "insert_leave",
      expose_as_code_action = { "fix_all", "add_missing_imports", "remove_unused_imports" },
    },
  })
end
