return {
	"folke/neodev.nvim",
	"folke/neoconf.nvim",
	"stevearc/dressing.nvim",
	"j-hui/fidget.nvim",
	"neovim/nvim-lspconfig",
	-- Lua formatter
	"ckipp01/stylua-nvim",
	-- Flutter
	"akinsho/flutter-tools.nvim",
	{ "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
	"tpope/vim-abolish",        -- Find/Replace variants of a word
	"axvr/zepl.vim",            -- Iron REPL
	{
		"ray-x/lsp_signature.nvim", -- get lsp function hints as you type
		event = "VeryLazy",
		opts = {},
		config = function(_, opts) require 'lsp_signature'.setup(opts) end
	},
};
