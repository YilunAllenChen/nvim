-- icons
return {
	'nvim-tree/nvim-web-devicons',
	commit = '8b2e5ef9eb8a717221bd96cb8422686d65a09ed5',
	lazy = true,
	config = function()
		require('nvim-web-devicons').setup {
			override = {
				zsh = {
					icon = '',
					color = '#428850',
					cterm_color = '65',
					name = 'Zsh',
				},
			},
			color_icons = true,
			default = true,
			strict = true,
			override_by_filename = {
				['.gitignore'] = {
					icon = '',
					color = '#f1502f',
					name = 'Gitignore',
				},
			},
			override_by_extension = {
				['log'] = {
					icon = '',
					color = '#81e043',
					name = 'Log',
				},
			},
		}
	end,
}
