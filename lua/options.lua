require("config.remote_clipboard").setup()  -- OSC-52 clipboard (matters inside tmux/ssh)
-- filename: options.lua
-- path: lua/options.lua

local opt          = vim.opt
local g            = vim.g

opt.number         = true
opt.relativenumber = true
opt.signcolumn     = "auto"
opt.wrap           = false
opt.spell          = false

opt.guicursor      = ""

opt.tabstop        = 4
opt.softtabstop    = 4
opt.shiftwidth     = 4
opt.expandtab      = true

opt.smartindent    = true

opt.swapfile       = false
opt.backup         = false
opt.undodir        = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile       = true

opt.hlsearch       = true
opt.incsearch      = true

opt.termguicolors  = true

opt.scrolloff      = 8
opt.signcolumn     = "yes"
opt.isfname:append("@-@")

opt.updatetime  = 50

opt.colorcolumn = "80"

opt.list        = true
opt.listchars:append("trail:·") -- show trailing spaces as ·
opt.listchars:append("nbsp:␣") -- non-breaking space

g.mapleader                = " "
g.autoformat_enabled       = true
g.cmp_enabled              = true
g.autopairs_enabled        = true
g.diagnostics_mode         = 3
g.icons_enabled            = true
g.ui_notifications_enabled = true
g.resession_enabled        = false
