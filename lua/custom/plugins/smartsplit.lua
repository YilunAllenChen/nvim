return {
  'mrjones2014/smart-splits.nvim',
  config = function()
    require('smart-splits').setup {
      ignored_buftypes = {
        'quickfix',
        'nofile',
        'prompt',
        'terminal',
		'nvimtree',
      },
    }
  end,
}
