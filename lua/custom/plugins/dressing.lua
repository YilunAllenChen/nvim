-- prettier ui
return {
  'stevearc/dressing.nvim',
  config = function()
    require('dressing').setup {
      input = {
        -- relative = "editor",
      },
    }
  end,
}
