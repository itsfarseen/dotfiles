local on_attach = require("config.lsp-keybindings").on_attach
vim.g.rustaceanvim = {
	tools = {
		autoSetHints = true,
		inlay_hints = { only_current_line = false },
	},
	server = {
		on_attach = on_attach,
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
