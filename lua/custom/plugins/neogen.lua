return {
  'danymat/neogen',
  event = 'VeryLazy',
  config = true,
  setup = function()
    require('neogen').setup {
      languages = {
        python = { template = { annotation_convention = 'google_docstrings' } },
      },
    }
  end,
}
