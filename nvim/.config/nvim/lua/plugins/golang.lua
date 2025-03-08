return {
	{
		"maxandron/goplements.nvim",
		ft = "go",
		opts = {
			prefix = {
				interface = "implemented by: ",
				struct = "implements: ",
			},
			display_package = true,
			namespace_name = "goplements",
			highlight = "Goplements",
		},
	},
	{
		"cademichael/gotest.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			-- defaults
			vim.g.gotest = {
				test_cmd = "go test -run ",
				preview_cutoff = 0,
				preview_width = 0.67,
			}
			local goTest = require("gotest")
			vim.keymap.set("n", "<Space>ct", goTest.goFuncTester, { desc = "[T]est Function" })
			-- vim.keymap.set("n", "<Space>cm", goTest.goModTester)
		end,
	},
	{
		"devkvlt/go-tags.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			commands = {
				["GoTagsAddJSON"] = { "-add-tags", "json" },
				["GoTagsRemoveJSON"] = { "-remove-tags", "json" },
				["GoTagsAddYAML"] = { "-add-tags", "yaml" },
				["GoTagsRemoveYAML"] = { "-remove-tags", "yaml" },
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"Snikimonkd/cmp-go-pkgs",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				sources = {
					{ name = "go_pkgs" },
				},
				-- to use . and / in urls
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
