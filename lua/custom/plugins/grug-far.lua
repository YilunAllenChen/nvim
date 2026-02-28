return {
  'MagicDuck/grug-far.nvim',
  event = 'VeryLazy',
  config = function() require('grug-far').setup {} end,
  keys = {
    { '<leader>r', '<cmd>GrugFar<cr>', desc = 'Grug search & replace' },
  },
}
