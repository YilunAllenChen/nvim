-- JUMP ANYWHERE!!!!
return {
  'smoka7/hop.nvim',
  lazy = true,
  cmd = { 'HopWord' },
  config = function()
    require('hop').setup {
      multi_windows = true,
    }
  end,
}
