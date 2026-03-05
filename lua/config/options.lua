-- [basics] --
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 5

-- [Indentation] --
vim.opt.list = true
vim.opt.listchars = {
  tab = "▸ ",        -- tab affiché comme ▸ + espace
  trail = "·",       -- espace en fin de ligne
  extends = "…",     -- ligne trop longue à droite
  precedes = "…",    -- ligne trop longue à gauche
}
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.autoindent = true

-- [Search settings] --
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false

-- [Visual settings] --
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.cmdheight = 1
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.showmode = false
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.conceallevel = 0
vim.opt.concealcursor = ""
vim.opt.lazyredraw = false
vim.opt.synmaxcol = 300

-- [File handling] --
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.autoread = true
vim.opt.autowrite = true

-- [Behavior settings] --
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false
vim.opt.path:append("**")
vim.opt.selection = "exclusive"
vim.opt.mouse = 'a'
vim.opt.clipboard:append("unnamedplus")
vim.opt.modifiable = true
vim.opt.encoding = "UTF-8"

vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#FFA500", ctermbg = 214 })
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 130 })
  end,
})
