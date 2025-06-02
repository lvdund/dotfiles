return {
	-- Highlight todo, notes, etc in comments
	{ 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
	{ -- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		main = 'nvim-treesitter.configs', -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'go', 'gowork', 'gomod' },
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { 'ruby' },
			},
			indent = { enable = true, disable = { 'ruby' } },
		},
	},
	{
		"Wansmer/symbol-usage.nvim",
		event = "LspAttach",
		config = function()
			local function h(name)
				return vim.api.nvim_get_hl(0, { name = name })
			end
			vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
			vim.api.nvim_set_hl(
				0,
				"SymbolUsageContent",
				{ bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true }
			)
			vim.api.nvim_set_hl(0, "SymbolUsageRef",
				{ fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
			vim.api.nvim_set_hl(0, "SymbolUsageDef",
				{ fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
			vim.api.nvim_set_hl(0, "SymbolUsageImpl",
				{ fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })
			local function text_format(symbol)
				local res = {}
				local round_start = { "", "SymbolUsageRounding" }
				local round_end = { "", "SymbolUsageRounding" }
				local stacked_functions_content = symbol.stacked_count > 0 and
					("+%s"):format(symbol.stacked_count)
					or ""
				if symbol.references then
					local usage = symbol.references <= 1 and "usage" or "usages"
					local num = symbol.references == 0 and "no" or symbol.references
					table.insert(res, round_start)
					table.insert(res, { "󰌹 ", "SymbolUsageRef" })
					table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
					table.insert(res, round_end)
				end
				if symbol.definition then
					if #res > 0 then
						table.insert(res, { " ", "NonText" })
					end
					table.insert(res, round_start)
					table.insert(res, { "󰳽 ", "SymbolUsageDef" })
					table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
					table.insert(res, round_end)
				end
				if symbol.implementation then
					if #res > 0 then
						table.insert(res, { " ", "NonText" })
					end
					table.insert(res, round_start)
					table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
					table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
					table.insert(res, round_end)
				end
				if stacked_functions_content ~= "" then
					if #res > 0 then
						table.insert(res, { " ", "NonText" })
					end
					table.insert(res, round_start)
					table.insert(res, { " ", "SymbolUsageImpl" })
					table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
					table.insert(res, round_end)
				end
				return res
			end
			require("symbol-usage").setup({
				text_format = text_format,
			})
		end,
	},
	{
		"xzbdmw/colorful-menu.nvim",
		config = function()
			require("colorful-menu").setup({
				ls = {
					lua_ls = {
						arguments_hl = "@comment",
					},
					gopls = {
						align_type_to_right = true,
						add_colon_before_type = false,
						preserve_type_when_truncate = true,
					},
					fallback = true,
				},
				fallback_highlight = "@variable",
				max_width = 60,
			})
		end,
	},
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {},
	}
}
