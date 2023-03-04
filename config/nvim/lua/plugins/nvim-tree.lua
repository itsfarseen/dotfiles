return function(use)
	use {
			"kyazdani42/nvim-tree.lua",
			requires = { "kyazdani42/nvim-web-devicons" },
			config = function()
				local tree_cb = require("nvim-tree.config").nvim_tree_callback
				require("nvim-tree").setup({
						filters = {
								custom = { ".git" },
						},
						view = {
								mappings = {
										list = {
												{ key = { "l" }, cb = tree_cb("edit") },
												{ key = { "h" }, cb = tree_cb("close_node") },
										},
								},
						},
				})
				vim.cmd([[
			 nnoremap <leader>e <cmd>NvimTreeOpen<cr><cmd>NvimTreeFocus<cr>
			 nnoremap <leader>E <cmd>NvimTreeClose<cr>
			 nnoremap <leader>o <c-w><c-p>
		 ]])
			end,
	};
end
