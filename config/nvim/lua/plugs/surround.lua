return {
	{
		"ur4ltz/surround.nvim",
		config = function()
			require("surround").setup({
				mappings_style = "sandwich",
				space_on_closing_char = true
			})
		end,
	},
}
