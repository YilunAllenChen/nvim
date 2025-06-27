-- context highlighting plugin
return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {},
  config = function()
    require('ibl').setup {
      scope = { priority = 100 },
    }
  end,
}
