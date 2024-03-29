return {
	{
		'averms/black-nvim',
		config = function()
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.py",
				command = "call BlackSync()",
			})
		end,
		build = function() vim.cmd("UpdateRemotePlugins") end
	}
}
