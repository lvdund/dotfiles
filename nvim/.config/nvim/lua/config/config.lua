vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a" -- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.showmode = false
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.colorcolumn = "90"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
-- vim.opt.scrolloff = 4

-- setup vim opt
vim.opt.signcolumn = "auto"
vim.opt.wrap = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
-- vim.o.foldcolumn = "1"
-- vim.cmd("highlight FoldColumn guibg=darkgrey")

-- Color-notify
vim.opt.termguicolors = true

-- disable deprecated messages
-- vim.deprecate = function() end
