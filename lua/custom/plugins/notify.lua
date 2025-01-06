return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  config = function()
    require('notify').setup {
      merge_duplicates = false,
      level = vim.log.levels.WARN,
      stages = 'slide',
      timeout = 3000,
      render = 'wrapped-compact',
      top_down = false,
      fps = 60,
    }
  end,
}
