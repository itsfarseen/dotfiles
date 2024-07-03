return {
	{
		"sheerun/vim-polyglot",
		config = function()
			-- Formatting is done by the LSP
			vim.g.zig_fmt_autosave = false;
		end
	}
}
