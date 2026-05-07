vim.cmd("highlight ColorColumn ctermbg=0 guibg=lightgrey")

local opt = vim.opt

-- show whitespaces
opt.list = true
opt.listchars:append({
    tab = ">·",
    trail = "~",
    eol = "¬",
    space = "·",
})

opt.expandtab = true
opt.smartindent = true
opt.tabstop = 4
opt.shiftwidth = 4
-- line numbers
-- o
opt.relativenumber = true
opt.number = true
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- folding
-- opt.foldenable = false
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldmethod = "expr"
opt.foldlevel = 99
opt.foldlevelstart = 4
