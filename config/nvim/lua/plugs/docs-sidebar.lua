return {
	{
		"amrbashir/nvim-docs-view",
		config = function()
			require("docs-view").setup({
				position = "right",
				width = 60,
				-- update_mode = "auto",
			})
			vim.keymap.set("n", "<leader>L", "<cmd>DocsViewToggle<CR>", {})
			vim.keymap.set("n", "L", "<cmd>DocsViewUpdate<CR>", {})
		end
	}
}
