return {
  'sustech-data/wildfire.nvim',
  event = 'BufReadPost',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function() require('wildfire').setup() end,
}
