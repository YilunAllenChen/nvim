return {
  'folke/tokyonight.nvim',
  priority = 1000,
  config = function()
    require('tokyonight').setup {
      style = 'moon',
      dim_inactive = true, -- darken inactive splits so active window stands out
      on_highlights = function(hl, c) hl.WinSeparator = { fg = c.blue, bold = true } end, -- brighter split divider
    }
    vim.cmd.colorscheme 'tokyonight-moon'
    vim.opt.fillchars:append { vert = '│', horiz = '─', horizup = '┴', horizdown = '┬', vertleft = '┤', vertright = '├', verthoriz = '┼' }
  end,
}
