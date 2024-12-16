return {
  'rcarriga/nvim-notify',
  config = function()
    require('notify').setup {
      level = 'warn',
      stages = 'slide',
      timeout = 3000,
      render = 'compact',
      top_down = false,
      fps = 60,
    }
  end,
}
