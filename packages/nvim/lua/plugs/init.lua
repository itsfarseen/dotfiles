return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta",  lazy = true }, -- `vim.uv` typings
	"folke/neoconf.nvim",
	"stevearc/dressing.nvim",
	"j-hui/fidget.nvim",
	"microsoft/python-type-stubs",
	"neovim/nvim-lspconfig",
	-- Load project-local VS Code settings (.vscode/settings.json) into LSP configs
	{
		"mrjones2014/codesettings.nvim",
		lazy = false,
		opts = {
			jsonls_integration = true, -- schema completion when editing .vscode/settings.json
			jsonc_filetype = true, -- treat the settings files as jsonc (comments/trailing commas)
		},
	},
	-- Lua formatter
	"ckipp01/stylua-nvim",
	-- Flutter
	"akinsho/flutter-tools.nvim",
	{ "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
	"tpope/vim-abolish", -- Find/Replace variants of a word
};
