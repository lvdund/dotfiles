return {
	{
		"Bekaboo/dropbar.nvim",
		-- optional, but required for fuzzy finder support
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		config = function()
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
	},
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{
		"SmiteshP/nvim-navic",
		dependencies = { "neovim/nvim-lspconfig" },
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},
	-- For highlight pannel
	-- {
	-- 	"nvim-zh/colorful-winsep.nvim",
	-- 	config = true,
	-- 	event = { "WinLeave" },
	-- },
	{
		"ya2s/nvim-cursorline",
		config = function()
			require("nvim-cursorline").setup({
				cursorline = {
					enable = true,
					timeout = 1000,
					number = false,
				},
				cursorword = {
					enable = true,
					min_length = 3,
					hl = { underline = true },
				},
			})
		end,
	},
	{
		"karb94/neoscroll.nvim",
		opts = {},
	},
	-- {
	-- 	"Isrothy/neominimap.nvim",
	-- 	version = "v3.*.*",
	-- 	enabled = true,
	-- 	lazy = false,
	-- 	keys = {
	-- 		{ "<leader>nm", "<cmd>Neominimap toggle<cr>", desc = "Toggle global minimap" },
	-- 		{ "<leader>nn", "<cmd>Neominimap toggleFocus<cr>", desc = "Switch focus on minimap" },
	-- 	},
	-- 	init = function()
	-- 		-- The following options are recommended when layout == "float"
	-- 		vim.g.neominimap = {
	-- 			auto_enable = true,
	-- 			x_multiplier = 5,
	-- 			float = {
	-- 				minimap_width = 8,
	-- 				margin = {
	-- 					right = 0,
	-- 					top = 0,
	-- 					bottom = 0,
	-- 				},
	-- 			},
	-- 			click = {
	-- 				enabled = true,
	-- 				auto_switch_focus = true,
	-- 			},
	-- 		}
	-- 	end,
	-- },
	-- {
	-- 	"folke/zen-mode.nvim",
	-- 	opts = {
	-- 		window = {
	-- 			width = 0.85, -- width will be 85% of the editor width
	-- 		},
	-- 	},
	-- },
}
