local on_attach = require("config.lsp-keybindings").on_attach
vim.g.rustaceanvim = {
	tools = {
		enable_clippy = false,
	},
	server = {
		on_attach = on_attach,
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

-- The global `vim.lsp.config("*", ...)` hook in config/lsp-config.lua does NOT fire for
-- rust-analyzer under rustaceanvim, so wire up codesettings.nvim directly here.
vim.lsp.config("rust-analyzer", {
	before_init = function(init_params, config)
		require("codesettings").with_local_settings(config.name, config)
		-- Some rust-analyzer settings must be sent at init time (e.g. non-Cargo
		-- build systems, rust-analyzer.workspace.discoverConfig).
		if config.default_settings and config.default_settings[config.name] then
			init_params.initializationOptions = config.default_settings[config.name]
		end
	end,
})

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
		version = "^9", -- requires Neovim 0.12+
		lazy = false, -- This plugin is already lazy
		dependencies = { "mrjones2014/codesettings.nvim" },
	},
}
