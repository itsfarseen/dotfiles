require("neoconf").setup()
require("neodev").setup({
	library = {
		enabled = true,
		runtime = true,
		types = true,
		plugins = true
	},
	setup_jsonls = true,
	lspconfig = true,
	pathStrict = true
})
require("fidget").setup(require("fidget-config"))
require("config.lsp-config")

local on_attach = require("config.lsp-keybindings").on_attach;
require("null-ls").setup({
	on_attach = on_attach,
})
require("prettier").setup({
	bin = 'prettier', -- or `prettierd`
	filetypes = {
		"css",
		"graphql",
		"html",
		"javascript",
		"javascriptreact",
		"json",
		"less",
		"markdown",
		"scss",
		"typescript",
		"typescriptreact",
		"yaml",
	},
	-- prettier format options (you can use config files too. ex: `.prettierrc`)
	arrow_parens = "always",
	bracket_spacing = true,
	embedded_language_formatting = "auto",
	end_of_line = "lf",
	html_whitespace_sensitivity = "css",
	jsx_bracket_same_line = false,
	jsx_single_quote = false,
	print_width = 80,
	prose_wrap = "preserve",
	quote_props = "as-needed",
	semi = true,
	single_quote = false,
	tab_width = 2,
	trailing_comma = "es5",
	use_tabs = false,
	vue_indent_script_and_style = false,
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
