-- Core options and globals

local options = {
  opt = {
    autochdir = false,
    cmdheight = 0, -- hide command line unless needed
    pumheight = 10, -- height of the pop up menu
    showtabline = 2, -- always display tabline
    splitbelow = true, -- splitting a new window below the current one
    splitright = true, -- splitting a new window at the right of the current one
    termguicolors = true, -- set term gui colors (most terminals support this)
    cursorline = true,
    cursorlineopt = 'number',
    smartindent = false,
    shiftwidth = 4,
    tabstop = 4,
    hlsearch = true,
    mouse = 'a',
    breakindent = true,
    undofile = true,
    ignorecase = true,
    smartcase = true,
    timeoutlen = 500, -- shorten key timeout length a little bit for which-key
    updatetime = 300, -- length of time to wait before triggering the plugin
    completeopt = 'menu,menuone,preview',
    number = true,
    relativenumber = true,
    signcolumn = 'yes',
  },
  g = {
    mapleader = ' ',
    maplocalleader = ' ',
    max_file = { size = 1024 * 100, lines = 1000 },
    diagnostics_mode = 3,
    icons_enabled = true,
    lsp_handlers_enabled = true,
    cmp_enabled = true,

    codeium_disable_bindings = 1,
  },
}

for scope, tbl in pairs(options) do
  for setting, value in pairs(tbl) do
    vim[scope][setting] = value
  end
end

vim.diagnostic.config {
  virtual_text = true,
}

if vim.fn.executable 'fish' == 1 then vim.opt.shell = 'fish' end

-- Neovide GUI settings
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0
  vim.o.guifont = 'FiraCode Nerd Font:h13'
  vim.g.neovide_position_animation_length = 0.0
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_transparency = 0.95
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
