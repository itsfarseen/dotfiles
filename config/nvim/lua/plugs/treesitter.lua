return {
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
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
					"json",
					"jsonc",
					"lua",
					"nix",
					"python",
					"rust",
					"typescript",
					"zig",
				},
				auto_install = true, -- Install missing parsers when you open a file
				sync_install = false, -- sync/async for ensure_installed
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
				indent = {
					enable = true
				},
				modules = {}
			})
		end
	}
}
