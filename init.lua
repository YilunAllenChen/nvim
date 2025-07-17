vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- let nvim use fish is available
if vim.fn.executable 'fish' == 1 then
  vim.opt.shell = 'fish'
end

if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.2
  vim.o.guifont = 'FiraCode Nerd Font:h14'
  vim.g.neovide_position_animation_length = 0.0
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_transparency = 0.9
end

-- Install package manager
--    https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local options = {
  opt = {
    autochdir = false,
    cmdheight = 0, -- hide command line unless needed
    clipboard = vim.env.SSH_TTY and '' or 'unnamedplus', -- Sync with system clipboard
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
    max_file = { size = 1024 * 100, lines = 1000 }, -- set global limits for large files
    diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available)
    lsp_handlers_enabled = true, -- enable or disable default vim.lsp.handlers (hover and signature help)
    cmp_enabled = true, -- enable completion at start

    -- codeium
    codeium_disable_bindings = 1,
    codeium_server_config = {
      portal_url = 'https://codeium.drwholdings.com',
      api_url = 'https://codeium.drwholdings.com/_route/api_server',
    },
  },
}

for scope, table in pairs(options) do
  for setting, value in pairs(table) do
    vim[scope][setting] = value
  end
end
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

require 'mapping'
require 'autocmds'

require('lazy').setup({
  { import = 'custom.plugins' },
  { import = 'custom.themes' },
}, {})
