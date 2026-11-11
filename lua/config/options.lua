-- Editor options. See `:help option-list` for everything available.

-- Leader keys: <Space> for global mappings, "\" for filetype-local ones.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Line numbers: absolute on the current line, relative everywhere else.
opt.number = true
opt.relativenumber = true

-- Indentation: 2 spaces by default. Per-language tweaks go in after/ftplugin/.
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Search: case-insensitive unless the pattern contains a capital letter.
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split" -- live preview of :s substitutions

-- Interface
opt.mouse = "a" -- mouse works in every mode
opt.signcolumn = "yes" -- always show the sign column so text doesn't shift
opt.cursorline = true -- highlight the current line
opt.scrolloff = 8 -- keep 8 lines visible above/below the cursor
opt.wrap = false -- don't soft-wrap long lines
opt.splitright = true -- vertical splits open to the right
opt.splitbelow = true -- horizontal splits open below
opt.confirm = true -- ask to save instead of failing on :q with unsaved changes

-- Behaviour
opt.clipboard = "unnamedplus" -- share the macOS system clipboard
opt.undofile = true -- keep undo history after closing a file
opt.updatetime = 250 -- faster CursorHold events (used by LSP/gitsigns later)
opt.timeoutlen = 300 -- how long to wait for a mapped key sequence
