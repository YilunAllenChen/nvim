-- Let things rain
return {
  'eandrju/cellular-automaton.nvim',
  event = 'VeryLazy',
  lazy = true,
  as = 'cellular-automaton',
  keys = {

    { '<leader>fml', '<cmd>CellularAutomaton make_it_rain<cr>', desc = 'Make It Rain!!!' },
    { '<leader>fmg', '<cmd>CellularAutomaton game_of_life<cr>', desc = 'Game Of Life!!!' },
    { '<leader>fms', '<cmd>CellularAutomaton scramble<cr>', desc = 'SCRABLE!!!' },
  },
}
