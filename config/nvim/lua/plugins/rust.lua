on_attach = require("config.lsp-keybindings").on_attach;

return function(use)
	use {
			"saecki/crates.nvim",
			requires = { 'nvim-lua/plenary.nvim' },
			config = function() require("crates").setup() end
	};
	use {
			"simrat39/rust-tools.nvim",
			config = function()
				require("rust-tools").setup({
						tools = { autoSetHints = true, inlay_hints = { only_current_line = false } },
						server = {
								on_attach = on_attach,
								settings = {
										["rust-analyzer"] = {
												cargo = {
														-- features = {"test-bpf"},
												},
										},
								},
						},
				})
			end,
	};
end
