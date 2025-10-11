return {
  'chrisgrieser/nvim-early-retirement',
  config = function()
    require('early-retirement').setup {
      retirementAgeMins = 1,
    }
  end,
  event = 'VeryLazy',
}
