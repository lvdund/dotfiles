return { -- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	opts = {
		preset = "helix",
		delay = 0,
		icons = {
			mappings = true,
			-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
			-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
			keys = {
				Up = "<Up> ",
				Down = "<Down> ",
				Left = "<Left> ",
				Right = "<Right> ",
				C = "<C-…> ",
				M = "<M-…> ",
				D = "<D-…> ",
				S = "<S-…> ",
				CR = "<CR> ",
				Esc = "<Esc> ",
				ScrollWheelDown = "<ScrollWheelDown> ",
				ScrollWheelUp = "<ScrollWheelUp> ",
				NL = "<NL> ",
				BS = "<BS> ",
				Space = "<Space> ",
				Tab = "<Tab> ",
				F1 = "<F1>",
				F2 = "<F2>",
				F3 = "<F3>",
				F4 = "<F4>",
				F5 = "<F5>",
				F6 = "<F6>",
				F7 = "<F7>",
				F8 = "<F8>",
				F9 = "<F9>",
				F10 = "<F10>",
				F11 = "<F11>",
				F12 = "<F12>",
			},
		},

		-- Document existing key chains
		spec = {
			{ "<leader>b", group = "[B]uffer" },
			{ "<leader>c", group = "[C]ocde" },
			{ "<leader>e", group = "[E]rror" },
			{ "<leader>m", group = "[M]ark" },
			{ "<leader>n", group = "MiniMap" },
			{ "<leader>g", group = "[G]it", mode = { "n", "v" } },
			-- { "<leader>q", group = "[Q]uit" },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>sc", group = "[S]earch Todo-[C]omment" },
			{ "<leader>sd", group = "[S]earch [D]iagnostic" },
		},
	},
}
