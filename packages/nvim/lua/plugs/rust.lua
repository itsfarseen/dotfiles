local on_attach = require("config.lsp-keybindings").on_attach
vim.g.rustaceanvim = {
	tools = {
		autoSetHints = true,
		inlay_hints = { only_current_line = false },
		enable_clippy = false,
	},
	server = {
		on_attach = on_attach,
		ra_multiplex = { enable = true, host = "127.0.0.1", port = 27631 },
		standalone = false,
		default_settings = {
			["rust-analyzer"] = {
				cargo = {
					-- features = {"test-bpf"},
					-- features = "all",
					features = {},
				},
			},
		},
	},
}

return {
	{
		"saecki/crates.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("crates").setup()
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
}
