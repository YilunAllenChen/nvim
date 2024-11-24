return { -- Highlight, edit, and navigate code
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	main = 'nvim-treesitter.configs',
	opts = {
		ensure_installed = { "python", "lua", "json", "yaml" },
		auto_install = true,
		highlight = {
			enable = true,
		},
		indent = { enable = true },
	},
}
