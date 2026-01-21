-- Core options and globals

local options = {
  opt = {
    autochdir = false,
    cmdheight = 0, -- hide command line unless needed
    -- clipboard = vim.env.SSH_TTY and '' or 'unnamedplus', -- Sync with system clipboard
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

-- Diagnostics
vim.diagnostic.config {
  virtual_text = true,
}
