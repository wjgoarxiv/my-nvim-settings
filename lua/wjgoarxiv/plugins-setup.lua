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
    "Mofiqul/dracula.nvim",
    config = function()
      require("dracula").setup({
        transparent_bg = false,
        italic_comment = true,
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
  { "akinsho/toggleterm.nvim" },
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
    "3rd/image.nvim",
    build = false,
    lazy = false,
  },
}, {
  performance = {
    cache = {
      enabled = false,
    },
  },
})
