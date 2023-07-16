return function(use)
	use {
		"folke/tokyonight.nvim",
		config = function()
			require("tokyonight").setup({
				style = "night",
				transparent = false,
				styles = {
					sidebars = "dark",
				}
			})
			vim.cmd("colorscheme tokyonight")
		end,
	};
end
