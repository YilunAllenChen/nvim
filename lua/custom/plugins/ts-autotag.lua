return {
  'windwp/nvim-ts-autotag',
  event = 'BufReadPre',
  opts = {},
  config = function(...)
    require 'astronvim.plugins.configs.ts-autotag'(...)
  end,
}
