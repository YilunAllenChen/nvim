return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  opts = {
    -- add any custom options here
  },
  keys = {
    { '<leader>q', desc = 'Sessions' },
    {
      '<leader>qs',
      function() require('persistence').load() end,
      desc = 'load session for current dir',
    },
    {
      '<leader>qS',
      function() require('persistence').seldct() end,
      desc = 'select session',
    },
    {
      '<leader>ql',
      function() require('persistence').load { last = true } end,
      desc = 'load last session',
    },
  },
}
