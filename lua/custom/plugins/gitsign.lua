-- gitsign
return {
  'lewis6991/gitsigns.nvim',
  event = 'BufEnter',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr) end,
  },

  keys = {
    {
      '<leader>]g',
      function() require('gitsigns').nav_hunk 'next' end,
      desc = 'next git hunk',
    },
    {
      '<leader>[g',
      function() require('gitsigns').nav_hunk 'prev' end,
      desc = 'previous git hunk',
    },
    {
      '<leader>k',
      function() require('gitsigns').blame_line { full = true } end,
      desc = 'view git blame',
    },
  },
}
