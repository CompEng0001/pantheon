local opt = vim.opt

-- Display.
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.ruler = true
opt.showcmd = true
opt.showmatch = true
opt.showmode = false
opt.laststatus = 3
opt.cmdheight = 0
opt.signcolumn = "number"
opt.conceallevel = 0
opt.termguicolors = true
opt.background = "dark"

-- Searching.
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Indentation: preserve the old Vim defaults.
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smarttab = true
opt.smartindent = true

-- Editing.
opt.backspace = { "indent", "eol", "start" }
opt.modeline = true
opt.history = 500
opt.undofile = true
opt.autoread = true
opt.foldopen = "all"

-- Completion.
opt.completeopt = { "menuone", "noinsert", "noselect" }
opt.shortmess:append("c")
opt.belloff:append("ctrlg")

-- Responsiveness / mappings.
opt.updatetime = 100
opt.timeout = true
opt.timeoutlen = 5000
opt.ttimeoutlen = 100

-- Splits.
opt.splitbelow = true
opt.splitright = true
