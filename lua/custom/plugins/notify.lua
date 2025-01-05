return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  config = function()
    require('notify').setup {
      merge_duplicates = false,
      level = 'info',
      stages = 'slide',
      timeout = 3000,
      render = 'compact',
      top_down = false,
      fps = 60,
    }
  end,
}
