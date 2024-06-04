return {
	{
		'rmehri01/onenord.nvim',
		config = function()
			vim.cmd("colorscheme onenord")
			require('onenord').setup()
		end
	}
}
