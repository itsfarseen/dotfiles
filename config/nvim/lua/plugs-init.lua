require("neoconf").setup()
require("fidget").setup(require("fidget-config"))
require("config.lsp-config")

local on_attach = require("config.lsp-keybindings").on_attach;
require("null-ls").setup({
	on_attach = on_attach,
})
require("rust-tools").setup({
	tools = {
		autoSetHints = true,
		inlay_hints = { only_current_line = false },
	},
	server = {
		on_attach = on_attach,
		settings = {
			["rust-analyzer"] = {
				cargo = {
					-- features = {"test-bpf"},
					-- features = "all",
					features = {},
				},
			},
		},
	},
})
