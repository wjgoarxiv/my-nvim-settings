local opt = vim.opt -- for conciseness

-- line num
opt.relativenumber = true
opt.number = true

-- tab & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line 
opt.cursorline = true

--appearance 
opt.termguicolors = true
opt.signcolumn = "yes"

local gui_font_candidates = {
  "D2CodingLigature Nerd Font Mono:h14",
  "D2CodingLigature Nerd Font:h14",
}

for _, font in ipairs(gui_font_candidates) do
  local ok = pcall(function()
    opt.guifont = font
  end)
  if ok then
    vim.g.wjgoarxiv_guifont = font
    break
  end
end

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")
