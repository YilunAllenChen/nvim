package.path = package.path .. ';./?.lua'

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

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


-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!


local options = {
  opt = {
    cmdheight = 0,             -- hide command line unless needed
    clipboard = "unnamedplus", -- connection to the system clipboard
    pumheight = 10,            -- height of the pop up menu
    showtabline = 2,           -- always display tabline
    splitbelow = true,         -- splitting a new window below the current one
    splitright = true,         -- splitting a new window at the right of the current one
  },
  g = {
    mapleader = ' ',
    maplocalleader = ' ',
    max_file = { size = 1024 * 100, lines = 1000 }, -- set global limits for large files
    diagnostics_mode = 3,                           -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    icons_enabled = true,                           -- disable icons in the UI (disable if no nerd font is available)
    lsp_handlers_enabled = true,                    -- enable or disable default vim.lsp.handlers (hover and signature help)
    cmp_enabled = true,                             -- enable completion at start
  },
  o = {
    hlsearch = false,
    mouse = 'a',
    breakindent = true,
    undofile = true,
    ignorecase = true,
    smartcase = true,
    timeoutlen = 500, -- shorten key timeout length a little bit for which-key
    updatetime = 300, -- length of time to wait before triggering the plugin
    completeopt = 'menu,menuone,preview',
    termguicolors = true,
  },
  wo = {
    number = true,
    relativenumber = true,
    signcolumn = 'yes',
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

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

require("mapping")

local _border = "rounded"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = _border
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = _border
  }
)

vim.diagnostic.config {
  float = { border = _border }
}

require('lazy').setup({
  { import = 'custom.plugins' },
}, {})
