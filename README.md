# **my-nvim-settings**
::wjgoarxiv's private Neovim settings with lua::
## **What is this?**
This repository contains a custom Neovim configuration that aims to provide a smooth development experience with various plugins, language servers, and snippets. The configuration is organized in a modular structure to make it easy to maintain and extend.

## **Repository structure**
```shell
.
├── init.lua
├── lua
│   └── wjgoarxiv
│       ├── core
│       │   ├── colorscheme.lua
│       │   ├── keymaps.lua
│       │   └── options.lua
│       ├── plugins
│       │   ├── copilot.lua
│       │   ├── lsp
│       │   │   ├── lspconfig.lua
│       │   │   ├── lspsaga.lua
│       │   │   ├── mason.lua
│       │   │   └── null-ls.lua
│       │   ├── lualine.lua
│       │   ├── nvim-cmp.lua
│       │   ├── nvim-tree.lua
│       │   ├── telescope.lua
│       │   └── toggleterm.lua
│       └── plugins-setup.lua
└── plugin
    └── packer_compiled.lua
```
## **Plugins**
This configuration uses Packer as the plugin manager. Below is a list of installed plugins:

- `tokyonight.nvim` - A clean, dark Neovim theme.
- `vim-surround` - Easily manipulate surroundings in Vim.
- `nvim-tree.lua` - A file explorer tree for Neovim.
- `nvim-web-devicons` - Web icons for Neovim.
- `lualine.nvim` - A fast and light statusline.
- `telescope.nvim` - A highly extendable fuzzy finder.
- `nvim-cmp` - Autocompletion plugin for Neovim.
- `LuaSnip` - A snippet engine for Neovim.
- `copilot.vim` - GitHub Copilot integration for Vim.
- `mason.nvim` - Manage and install LSP servers.
- `nvim-lspconfig` - Configure and manage language servers.
- `lspsaga.nvim` - Enhanced LSP UIs for Neovim.
- `null-ls.nvim` - Configure formatters and linters for Neovim.
- `nvim-treesitter` - Syntax highlighting and more with tree-sitter.
- `nvim-autopairs` - Automatically close parentheses, brackets, quotes, etc.
- `nvim-ts-autotag` - Automatically close tags.
- `toggleterm.nvim` - An integrated terminal for Neovim.
- `markdown-preview.nvim` - A useful tool to preview markdown documents.

## **How to install?**
1. Make sure you have `Neovim >= 0.8` installed.
2. Clone this repository into your Neovim configuration directory:
```shell
git clone https://github.com/wjgoarxiv/my-nvim-settings.git ~/.config/nvim
```
3. Open Neovim and run :PackerSync to install the plugins.
4. Restart Neovim.

## **Usage**
This configuration provides a set of keymaps, options, and plugin configurations to enhance your Neovim experience. Please refer to the individual Lua files within the lua/wjgoarxiv directory to understand the setup and customization for each plugin and core feature.

Feel free to explore and modify the configuration to fit your needs.

## **References** 
1. [Awesome Neovim Setup From Scratch - Full Guide](https://www.youtube.com/watch?v=JWReY93Vl6g)
2. [How I Setup Neovim On My Mac To Make It Amazing - Complete Guide](https://youtu.be/vdn_pKJUda8)
3. [How to Configure Neovim to make it Amazing -- complete tutorial](https://youtu.be/J9yqSdvAKXY)
4. [Floating and split terminal - Neovim Lua From Scratch #18](https://youtu.be/Qtdbco50sPc)
