on_attach = require("config.lsp-keybindings").on_attach;

return function(use)
	use({
		'MunifTanjim/prettier.nvim',
		requires = { 'jose-elias-alvarez/null-ls.nvim' },
		config = function()
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
		end,
		after = "nvim-lspconfig",
	})
end
