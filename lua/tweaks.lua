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

local opt = vim.opt
opt.clipboard = 'unnamedplus'
if vim.env.SSH_CONNECTION then
  local function vim_paste()
    local content = vim.fn.getreg '"'
    return vim.split(content, '\n')
  end
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy '+',
      ['*'] = require('vim.ui.clipboard.osc52').copy '*',
    },
    paste = {
      ['+'] = vim_paste,
      ['*'] = vim_paste,
    },
  }
end
