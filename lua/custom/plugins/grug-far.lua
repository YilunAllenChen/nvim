return {
  'MagicDuck/grug-far.nvim',
  event = 'VeryLazy',
  config = function()
    require('grug-far').setup {
      -- options, see Configuration section below
      -- there are no required options atm
      -- engine = 'ripgrep' is default, but 'astgrep' can be specified
    }
  end,
  keys = {
    { '<leader>r', '<cmd>GrugFar<cr>', desc = 'Grug search & replace' },
  },
}
