return function(use)
	use {
			'nvim-treesitter/nvim-treesitter',
			run = ':TSUpdate',
			config = function()
				require("nvim-treesitter.configs").setup({
						ensure_installed = {
					"bash",
								"c",
								"cpp",
								"css",
								"go",
								"html",
								"javascript",
								"lua",
								"nix",
								"python",
								"rust",
								"typescript",
								"zig",
						},
						-- Install languages synchronously (only applied to `ensure_installed`)
						sync_install = false,
						-- List of parsers to ignore installing
						ignore_install = {},
						highlight = {
								-- `false` will disable the whole extension
								enable = true,

								-- list of language that will be disabled
								disable = {},

								-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
								-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
								-- Using this option may slow down your editor, and you may see some duplicate highlights.
								-- Instead of true it can also be a list of languages
								additional_vim_regex_highlighting = false,
						},
						incremental_selection = {
								enable = true,
								keymaps = {
						init_selection = "<CR>",
						node_incremental = "<CR>",
						scope_incremental = "<Tab>",
						node_decremental = "<S-Tab>",
								},
						},
				})

				require 'nvim-treesitter.configs'.setup {
						indent = {
								enable = true
						}
				}
			end
	};
end
