# **my-nvim-settings**
::wjgoarxiv's private Neovim settings with Lua::
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
│       │   ├── lsp
│       │   │   ├── lspconfig.lua
│       │   │   ├── lspsaga.lua
│       │   │   ├── mason.lua
│       │   │   └── null-ls.lua
│       │   ├── lualine.lua
│       │   ├── nvim-cmp.lua
│       │   ├── nvim-tree.lua
│       │   ├── telescope.lua
│       │   ├── toggleterm.lua
│       │   └── treesitter.lua
│       └── plugins-setup.lua
└── plugin
    └── packer_compiled.lua
```
## **Plugins**
This configuration uses Packer as the plugin manager. Key plugins include:

- `github-nvim-theme` – Transparent-friendly GitHub-inspired colors.
- `vim-surround`, `ReplaceWithRegister`, `Comment.nvim` – Quality-of-life editing helpers.
- `nvim-tree.lua` + `nvim-web-devicons` – File explorer with icons.
- `lualine.nvim` – Lightweight status line.
- `telescope.nvim` + `telescope-fzf-native.nvim` – Fuzzy finding with native sorter.
- `nvim-cmp`, `cmp-buffer`, `cmp-path`, `cmp-nvim-lsp` – Completion sources.
- `LuaSnip`, `cmp_luasnip`, `friendly-snippets` – Snippet engine and extras.
- `copilot.vim` – GitHub Copilot integration (opt-in when authenticated).
- `mason.nvim`, `mason-lspconfig.nvim`, `mason-null-ls.nvim` – Tooling & server management.
- `nvim-lspconfig`, `lspsaga.nvim`, `typescript-tools.nvim`, `lspkind.nvim` – LSP UX boosts.
- `nvimtools/none-ls.nvim` – Local formatters/linters (with optional `none-ls-extras` sources).
- `nvim-treesitter`, `nvim-autopairs`, `nvim-ts-autotag` – Syntax and editing niceties.
- `toggleterm.nvim` – Integrated terminal management.
- `markdown-preview.nvim` – Browser-based Markdown preview.
- `render-markdown.nvim` – Render Markdown directly inside Neovim buffers.

## **How to install?**
1. Ensure you have `Neovim >= 0.11` installed (older releases will emit deprecation warnings).
2. Back up any existing `~/.config/nvim` directory, then clone:
   ```shell
   git clone https://github.com/wjgoarxiv/my-nvim-settings.git ~/.config/nvim
   ```
3. Launch Neovim and let Packer bootstrap automatically, or run:
   ```shell
   nvim --headless +PackerSync +qa
   ```
4. Restart Neovim to load all compiled plugin config.

> **Tip:** If you want diagnostics/formatters like `eslint_d` or `shellcheck`, install [nvimtools/none-ls-extras.nvim](https://github.com/nvimtools/none-ls-extras.nvim) so those sources are available to none-ls.

## **Installation Guide for Neovim (version 0.11 or newer) on WSL2-based Ubuntu**
### (1) Prerequisites
- [x] Make sure you have WSL2 installed and set as your default version.
- [x] Verify that you are running an Ubuntu distribution.

### (2) Step-by-Step Installation
#### Update your system
```shell
sudo apt update
sudo apt upgrade
```

#### Install Required Tools
```
sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl
```

#### Clone the Neovim Repository
```
cd ~
git clone https://github.com/Neovim/Neovim.git
```

#### Checkout to the Desired Version
```
cd Neovim
git tag
```
Find the tag corresponding to the version you want and switch to it:
```
git checkout tags/<tag_name>
```
Replace <tag_name> with the tag corresponding to the version you want to install.

#### Build and Install
Now, you can build and install Neovim:
```
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```

#### Verify the Installation
To verify the installation, use the following command:
```
nvim --version
```
You now have Neovim (version 0.11 or newer) installed on your WSL2-based Ubuntu system.

## **Installation Guide for Neovim (version 0.11 or newer) on Mac**

Install the latest version of Neovim by typing: 

```
brew install neovim
```

Verify the installation: 

```
nvim --version
```

## **Usage**
This configuration provides a set of keymaps, options, and plugin configurations to enhance your Neovim experience. Please refer to the individual Lua files within the lua/wjgoarxiv directory to understand the setup and customization for each plugin and core feature.

Feel free to explore and modify the configuration to fit your needs.

## **References** 
1. [Awesome Neovim Setup From Scratch - Full Guide](https://www.youtube.com/watch?v=JWReY93Vl6g)
2. [How I Setup Neovim On My Mac To Make It Amazing - Complete Guide](https://youtu.be/vdn_pKJUda8)
3. [How to Configure Neovim to make it Amazing -- complete tutorial](https://youtu.be/J9yqSdvAKXY)
4. [Floating and split terminal - Neovim Lua From Scratch #18](https://youtu.be/Qtdbco50sPc)
