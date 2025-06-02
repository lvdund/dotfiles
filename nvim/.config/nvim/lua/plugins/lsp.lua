return {
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("grn", vim.lsp.buf.rename, "[R]e-[N]ame")
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					-- map("gf", require("telescope.builtin").lsp_document_symbols, "[F]ind Document Symbols")
					map("gf", function()
						local filetype = vim.bo.filetype
						local symbols_map = {
							lua = "function",
							go = { "method", "struct", "interface", "function", "constant", "variable" },
							java = "class",
						}
						local symbols = symbols_map[filetype] or "function"
						require("telescope.builtin").lsp_document_symbols({ symbols = symbols })
					end, "[G]oto [F]unction")
					map("gw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open [W]orkspace Symbols")
					map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("grh", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
			local diagnostic_signs = {}
			for type, icon in pairs(signs) do
				diagnostic_signs[vim.diagnostic.severity[type]] = icon
			end
			vim.diagnostic.config({ signs = { text = diagnostic_signs } })

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				gopls = {
					settings = {
						filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" },
						root_markers = { "go.mod", "go.work", ".git" },
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = true,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								fieldalignment = true,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
								unreachable = true,
								modernize = true,
								stylecheck = true,
								appends = true,
								asmdecl = true,
								assign = true,
								atomic = true,
								bools = true,
								buildtag = true,
								cgocall = true,
								composite = true,
								contextcheck = true,
								deba = true,
								atomicalign = true,
								composites = true,
								copylocks = true,
								deepequalerrors = true,
								defers = true,
								deprecated = true,
								directive = true,
								embed = true,
								errorsas = true,
								fillreturns = true,
								framepointer = true,
								gofix = true,
								hostport = true,
								infertypeargs = true,
								lostcancel = true,
								httpresponse = true,
								ifaceassert = true,
								loopclosure = true,
								nilfunc = true,
								nonewvars = true,
								noresultvalues = true,
								printf = true,
								shadow = true,
								shift = true,
								sigchanyzer = true,
								simplifycompositelit = true,
								simplifyrange = true,
								simplifyslice = true,
								slog = true,
								sortslice = true,
								stdmethods = true,
								stdversion = true,
								stringintconv = true,
								structtag = true,
								testinggoroutine = true,
								tests = true,
								timeformat = true,
								unmarshal = true,
								unsafeptr = true,
								unusedfunc = true,
								unusedresult = true,
								waitgroup = true,
								yield = true,
								unusedvariable = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							semanticTokens = true,
						},
					},
					-- capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), {
					-- 	fileOperations = {
					-- 		didRename = true,
					-- 		willRename = true,
					-- 	},
					-- }),
				},
				jdtls = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = { callSnippet = "Replace" },
							diagnostics = { globals = { "vim" } },
						},
					},
				},
				clangd = {
					cmd = { "/usr/bin/clangd" },
					filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
					root_dir = require("lspconfig").util.root_pattern(
						".clangd",
						".clang-tidy",
						".clang-format",
						"compile_commands.json",
						"compile_flags.txt",
						"configure.ac",
						".git"
					),
					single_file_support = true,
				},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = {
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
						winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
					},
					documentation = {
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
						winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
					},
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({

					-- Disable <Up> and <Down> for navigating the menu
					["<Down>"] = cmp.mapping(function(fallback)
						cmp.close()
						fallback()
					end, { "i" }),
					["<Up>"] = cmp.mapping(function(fallback)
						cmp.close()
						fallback()
					end, { "i" }), -- Select the [n]ext item

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-3),
					["<C-f>"] = cmp.mapping.scroll_docs(3),

					["<CR>"] = cmp.mapping.confirm({ select = true }),
					-- ["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<C-Space>"] = cmp.mapping.complete({}),

					-- ["<C-l>"] = cmp.mapping(function()
					-- 	if luasnip.expand_or_locally_jumpable() then
					-- 		luasnip.expand_or_jump()
					-- 	end
					-- end, { "i", "s" }),
					-- ["<C-h>"] = cmp.mapping(function()
					-- 	if luasnip.locally_jumpable(-1) then
					-- 		luasnip.jump(-1)
					-- 	end
					-- end, { "i", "s" }),
				}),
				sources = {
					{
						name = "lazydev",
						group_index = 0,
					},
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = true,
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gofmt", "goimports" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"go",
				"gomod",
				"gowork",
				"gosum",
				"java",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
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
			vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
			vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
			vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })
			local function text_format(symbol)
				local res = {}
				local round_start = { "", "SymbolUsageRounding" }
				local round_end = { "", "SymbolUsageRounding" }
				local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count)
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
	},
	{
		"mawkler/refjump.nvim",
		event = "LspAttach", -- Uncomment to lazy load
		opts = {
			keymaps = {
				enable = true,
				next = "]r", -- Keymap to jump to next LSP reference
				prev = "[r", -- Keymap to jump to previous LSP reference
			},
			highlights = {
				enable = true, -- Highlight the LSP references on jump
				auto_clear = true, -- Automatically clear highlights when cursor moves
			},
			integrations = {
				demicolon = {
					enable = true, -- Make `]r`/`[r` repeatable with `;`/`,` using demicolon.nvim
				},
			},
			verbose = true, -- Print message if no reference is found
		},
	},
}
