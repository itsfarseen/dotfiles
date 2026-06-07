return {
	{
		"wtfox/jellybeans.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("jellybeans").setup({
				transparent = false,
				italics = false,
				bold = true,
				flat_ui = false, -- toggles "flat UI" for pickers
				background = {
					dark = "jellybeans", -- default dark palette
					light = "jellybeans_light", -- default light palette
				},
				plugins = {
					all = false,
					auto = true, -- auto-detect installed plugins via lazy.nvim
				},
			})
			vim.cmd("colorscheme jellybeans-hc")
		end,
	},
	-- {
	-- 	"vague2k/vague.nvim",
	-- 	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	-- 	priority = 1000, -- make sure to load this before all the other plugins
	-- 	config = function()
	-- 		-- NOTE: you do not need to call setup if you don't want to.
	-- 		require("vague").setup({
	-- 			-- optional configuration here
	-- 		})
	-- 		vim.cmd("colorscheme vague")
	-- 	end,
	-- },
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("catppuccin").setup({
	-- 			flavour = "mocha", -- latte, frappe, macchiato, mocha
	-- 			transparent_background = true,
	-- 			float = {
	-- 				transparent = true, -- enable transparent floating windows
	-- 				solid = true, -- use solid styling for floating windows, see |winborder|
	-- 			},
	-- 		})
	-- 		vim.cmd("colorscheme catppuccin")
	-- 	end,
	-- },
}
