-- JUMP ANYWHERE!!!!
return {
  'smoka7/hop.nvim',
  lazy = true,
  cmd = { 'HopWord' },
  keys = {
    { ';', '<cmd>HopWord<cr>', desc = 'Hop' },
  },
  config = function()
    require('hop').setup {
      multi_windows = true,
    }
  end,
}
