return function(use)
	use {
		"nathom/filetype.nvim",
		config = function()
			vim.g.did_load_filetypes = 1
		end
	};
	use "sheerun/vim-polyglot";
end
