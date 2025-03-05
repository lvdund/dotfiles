return {
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("telescope").load_extension("projects")
			require("project_nvim").setup({
				patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "go.mod" },
				show_hidden = true,
			})
		end,
	},
}
