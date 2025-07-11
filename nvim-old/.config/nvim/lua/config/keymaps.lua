-- Keymap helper
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "'", ":", opts)
map("i", "jk", "<ESC>", opts)
map("n", "<leader><leader>", "<cmd>wa<cr>", { desc = "Write" })
-- map("n", "<leader>r", "<cmd>source /home/vd/.config/nvim/init.lua<cr>", { desc = "[R]eload nvim" })

-- General keymaps
map("n", "<C-left>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-right>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-down>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-up>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

map("n", "dw", "vb_d") -- delete a word backup
map("n", "<C-a>", "gg<S-v>G") -- select all

-- Move a line up or down in normal mode
map("n", "<A-down>", ":m .+1<CR>==", { desc = "Move line down", noremap = true, silent = true })
map("n", "<A-up>", ":m .-2<CR>==", { desc = "Move line up", noremap = true, silent = true })

-- Move a line or block up or down in visual mode
map("v", "<A-down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", noremap = true, silent = true })
map("v", "<A-up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", noremap = true, silent = true })

-- Resize window
map("n", "=", [[<cmd>vertical resize +5<cr>]])
map("n", "-", [[<cmd>vertical resize -5<cr>]])
map("n", "+", [[<cmd>horizontal resize +2<cr>]])
map("n", "_", [[<cmd>horizontal resize -2<cr>]])

-- split window
map("n", "ss", ":split<CR>", opts) -- up/down
map("n", "sv", ":vsplit<CR>", opts) -- left/right

-- notifycation
map("n", "<leader>nl", ":Telescope notify<CR>", { desc = "List Notifications" })
map("n", "<leader>nc", ":NotificationsClear", { desc = "Clear All Notifications" })

-- log
map("n", "<leader>scc", ":TodoTelescope<CR>", { desc = "List all TODO" })
map("n", "<leader>scn", function()
	require("todo-comments").jump_next()
end, { desc = "[N]ext TODO" })
map("n", "<leader>scp", function()
	require("todo-comments").jump_prev()
end, { desc = "[P]revious TODO" })

-- Diagnostic
map("n", "<leader>ee", vim.diagnostic.open_float, { desc = "Open Errors" })
map("n", "<leader>en", vim.diagnostic.goto_next, { desc = "[N]ext Error" })
map("n", "<leader>ep", vim.diagnostic.goto_prev, { desc = "[P]revious Error" })

-- Git
map("n", "<leader>gh", ":Gitsigns preview_hunk<CR>", { desc = "[G]itsigns [H]unk" })
map("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", { desc = "[G]itsigns toggle [T]ime" })
map("n", "<leader>gg", ":LazyGit<CR>", { desc = "Lazy[G]it" })
map("n", "<leader>gf", ":LazyGitFilterCurrentFile<CR>", { desc = "Current [F]ile" })
map("n", "<leader>gs", ":TermExec cmd='git status'<CR>", { desc = "[S]tatus" })

-- Neo-tree
map("n", "\\", "<Cmd>Neotree position=float reveal<CR>")

-- Quickfix
-- map("n", "<C-n>", ":cnext<CR>", { desc = "Next search list" })
-- map("n", "<C-p>", ":cprevious<CR>", { desc = "Previous search list" })
-- map("n", "qc", ":cclose<CR>", { desc = "[C]lose search list" })
-- map("n", "qq", ":copen<CR>", { desc = "[L]ist search list" })

-- Scroll
local neoscroll = require("neoscroll")
local keymap = {
	-- ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 250 }) end;
	-- ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 250 }) end;
	-- ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 450 }) end;
	-- ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 450 }) end;
	["<PageUp>"] = function()
		neoscroll.scroll(-0.1, { move_cursor = false, duration = 70 })
	end,
	["<PageDown>"] = function()
		neoscroll.scroll(0.1, { move_cursor = false, duration = 70 })
	end,
	-- ["zt"]    = function() neoscroll.zt({ half_win_duration = 250 }) end;
	-- ["zz"]    = function() neoscroll.zz({ half_win_duration = 250 }) end;
	-- ["zb"]    = function() neoscroll.zb({ half_win_duration = 250 }) end;
}
local modes = { "n", "v", "x" }
for key, func in pairs(keymap) do
	map(modes, key, func)
end

-- golang tags
map("n", "<leader>tajj", "<Cmd>GoAddTags json<CR>", { desc = "Add tag json" })
map("n", "<leader>tajo", "<Cmd>GoAddTags json,omitempty<CR>", { desc = "Add tag json with omitempty" })
map("n", "<leader>tayj", "<Cmd>GoAddTags yaml,omitempty<CR>", { desc = "Add tag yaml" })
map("n", "<leader>tayo", "<Cmd>GoAddTags yaml,omitempty<CR>", { desc = "Add tag yaml with omitempty" })
map("n", "<leader>trj", "<Cmd>GoRemoveTags json<CR>", { desc = "Remove tag json" })
map("n", "<leader>try", "<Cmd>GoRemoveTags yaml<CR>", { desc = "Remove tag yaml" })
