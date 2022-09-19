return function(use)
	use {
		"folke/tokyonight.nvim",
		config = function()
			vim.g.tokyonight_transparent = false
			vim.g.tokyonight_dark_sidebar = true
			vim.g.tokyonight_style = "storm"
			vim.cmd("colorscheme tokyonight")
		end,
	};
end
