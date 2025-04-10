local icons = {
	Error = " ",
	Warn = " ",
	Hint = " ",
	Info = " ",
}

return {
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
			{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "CLose Non-Pinned Buffers" },
			{ "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close other Buffers" },
			{ "<leader>bc", "<Cmd>bd<CR>", desc = "Close this Buffer" },
			{ "[c", "<Cmd>bd<CR>", desc = "Close this Buffer" },
			{ "]c", "<Cmd>bd<CR>", desc = "Close this Buffer" },
			{ "[b", "<Cmd>BufferLineMovePrev<CR>", desc = "Move Buffers Left" },
			{ "]b", "<Cmd>BufferLineMoveNext<CR>", desc = "Move Buffers Right" },
			{ "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		},
		opts = {
			highlights = {
				buffer_selected = {
					bold = true,
					italic = true,
				},
			},

			options = {
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(_, _, diag)
					local ret = (diag.error and icons.Error .. diag.error .. " " or "")
						.. (diag.warning and icons.Warn .. diag.warning or "")
					return vim.trim(ret)
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
					},
				},
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
				indicator = {
					icon = "▎", -- this should be omitted if indicator style is not 'icon'
					style = "underline",
				},
			},
		},
	},
	{
		"b0o/incline.nvim",
		config = function()
			require("incline").setup({
				window = {
					padding = 0,
					margin = { horizontal = 0 },
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if filename == "" then
						filename = "[No Name]"
					end
					local modified = vim.bo[props.buf].modified
					return {
						" ",
						{ filename, gui = modified and "bold,italic" or "bold" },
						" ",
						guibg = "#44406e",
					}
				end,
			})
		end,
		-- Optional: Lazy load Incline
		event = "VeryLazy",
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "dracula",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					always_show_tabline = true,
					globalstatus = false,
					refresh = {
						statusline = 100,
						tabline = 100,
						winbar = 100,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
}
