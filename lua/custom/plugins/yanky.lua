return {
  'gbprod/yanky.nvim',
  opts = {
    ring = { history_length = 20 },
    picker = { telescope = { use_default_mappings = false } },
    system_clipboard = {
      sync_with_ring = false,
      clipboard_register = nil,
    },
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 100,
    },
    preserve_cursor_position = {
      enabled = true,
    },
    textobj = {
      enabled = false,
    },
  },
  keys = {
    { '<C-p>', function() require('telescope').extensions.yank_history.yank_history() end, desc = 'Yank History' },
    { 'y', '<Plug>(YankyYank)', desc = 'Yanky Yank', mode = { 'n', 'x' } },
    { 'p', '<Plug>(YankyPutAfter)', desc = 'Yanky Put After' },
    { 'P', '<Plug>(YankyPutBefore)', desc = 'Yanky Put Before' },
  },
}
