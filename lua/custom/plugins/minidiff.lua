return {
  'echasnovski/mini.diff',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    view = {
      style = 'sign',
      signs = { add = '+', change = '~', delete = '-' },
    },
    mappings = {
      apply = 'gh',
      reset = 'gH',
      textobject = 'gh',
      goto_first = '[H',
      goto_prev = '[h',
      goto_next = ']h',
      goto_last = ']H',
    },
  },
  keys = {
    { '<leader>d', function() require('mini.diff').toggle_overlay() end, desc = 'Toggle inline diff overlay' },
    { '<leader>hs', 'ghgh', remap = true, desc = 'Stage hunk' },
    { '<leader>hr', 'gHgH', remap = true, desc = 'Reset hunk' },
  },
}
