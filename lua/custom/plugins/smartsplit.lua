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
  keys = {

    { '<C-Left>', function() require('smart-splits').resize_left() end, desc = 'resize_left' },
    { '<C-Down>', function() require('smart-splits').resize_down() end, desc = 'resize_down' },
    { '<C-Up>', function() require('smart-splits').resize_up() end, desc = 'resize_up' },
    { '<C-Right>', function() require('smart-splits').resize_right() end, desc = 'resize_right' },
    { '<C-h>', function() require('smart-splits').move_cursor_left() end, desc = 'move_cursor_left' },
    { '<C-j>', function() require('smart-splits').move_cursor_down() end, desc = 'move_cursor_down' },
    { '<C-k>', function() require('smart-splits').move_cursor_up() end, desc = 'move_cursor_up' },
    { '<C-l>', function() require('smart-splits').move_cursor_right() end, desc = 'move_cursor_right' },
    { '<leader><leader>h', function() require('smart-splits').swap_buf_left() end, desc = 'swap_buf_left' },
    { '<leader><leader>j', function() require('smart-splits').swap_buf_down() end, desc = 'swap_buf_down' },
    { '<leader><leader>k', function() require('smart-splits').swap_buf_up() end, desc = 'swap_buf_up' },
    { '<leader><leader>l', function() require('smart-splits').swap_buf_right() end, desc = 'swap_buf_right' },
  },
}
