local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        transparent = false,
        styles = {
          sidebars = "",
          floats = "",
        },
        sidebars = { "qf", "help", "NvimTree", "Outline", "terminal" },
      })
    end,
  },
  { "tpope/vim-surround" },
  { "vim-scripts/ReplaceWithRegister" },
  { "numToStr/Comment.nvim" },
  { "nvim-tree/nvim-tree.lua" },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        default = true,
      })
    end,
  },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },
  {
    "github/copilot.vim",
    config = function() end,
  },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/cmp-nvim-lsp" },
  {
    "nvimdev/lspsaga.nvim",
    branch = "main",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  { "onsails/lspkind.nvim" },
  { "nvimtools/none-ls.nvim" },
  { "jay-babu/mason-null-ls.nvim" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  { "windwp/nvim-autopairs" },
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-\\>", "<cmd>Yazi<cr>", desc = "Open yazi at current file", mode = { "n" } },
    },
    opts = {
      open_for_directories = false,
      config_home = vim.fs.joinpath(vim.fn.stdpath("config"), "yazi"),
      set_keymappings_function = function(yazi_buffer)
        vim.keymap.set("t", "<C-\\>", function()
          vim.api.nvim_feedkeys("q", "t", false)
        end, { buffer = yazi_buffer, desc = "Close yazi" })
      end,
      keymaps = {
        change_working_directory = false,
        copy_relative_path_to_selected_files = false,
      },
      hooks = {
        yazi_closed_successfully = function(_, _, state)
          local last_directory = state and state.last_directory
          local root = last_directory and last_directory.filename

          if not root or vim.fn.isdirectory(root) ~= 1 then
            return
          end

          local ok, api = pcall(require, "nvim-tree.api")
          if ok then
            api.tree.change_root(root)
          end
        end,
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      { "echasnovski/mini.nvim", lazy = true },
    },
    config = function()
      require("render-markdown").setup({})
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
  },
}, {
  performance = {
    cache = {
      enabled = false,
    },
  },
})
