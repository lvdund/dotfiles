return {
	"nvim-java/nvim-java",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	ft = "java",
	opts = {
		jdk = {
			auto_install = false,
		},
		notifications = {
			dap = false,
		},
		spring_boot_tools = {
			enable = false,
		},
	},
}
