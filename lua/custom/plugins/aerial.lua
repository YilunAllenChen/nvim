-- document / workspace outline
return {
	'stevearc/aerial.nvim',
	lazy = true,
	opts = {

		attach_mode = 'global',
		backends = { 'lsp', 'treesitter', 'markdown', 'man' },
		disable_max_lines = vim.g.max_file.lines,
		disable_max_size = vim.g.max_file.size,
		layout = { min_width = 28, width = 50 },
		show_guides = true,
		filter_kind = false,
		guides = {
			mid_item = '├ ',
			last_item = '└ ',
			nested_top = '│ ',
			whitespace = '  ',
		},
		keymaps = {
			['[y'] = 'actions.prev',
			[']y'] = 'actions.next',
			['[Y'] = 'actions.prev_up',
			[']Y'] = 'actions.next_up',
			['{'] = false,
			['}'] = false,
			['[['] = false,
			[']]'] = false,
		},
	},
}
