return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"fnune/recall.nvim",
		config = function()
			require("recall").setup({})
		end,
	},
}
