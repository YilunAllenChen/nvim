-- Shell & GUI tweaks

-- Prefer fish as shell when available
if vim.fn.executable 'fish' == 1 then vim.opt.shell = 'fish' end

-- Neovide GUI settings
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0
  vim.o.guifont = 'FiraCode Nerd Font:h12'
  vim.g.neovide_position_animation_length = 0.0
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_transparency = 0.9
end

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy '+',
    ['*'] = require('vim.ui.clipboard.osc52').copy '*',
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste '+',
    ['*'] = require('vim.ui.clipboard.osc52').paste '*',
  },
}
