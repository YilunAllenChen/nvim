-- display color codes in color
return {
	'norcalli/nvim-colorizer.lua',
	config = function()
		require('colorizer').setup({}, {
			name = false,  -- #FF0000
		})
	end,
}
