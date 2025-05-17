return {
	{
		"amrbashir/nvim-docs-view",
		config = function()
			require("docs-view").setup({
				position = "right",
				width = 30,
				update_mode = "manual",
			})
			vim.keymap.set("n", "<leader>L", "<cmd>DocsViewUpdate<CR>", {})
			vim.keymap.set("n", "L", "<cmd>DocsViewUpdate<CR>", {})
		end
	}
}
