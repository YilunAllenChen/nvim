-- Core options and globals

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

for scope, tbl in pairs(options) do
  for setting, value in pairs(tbl) do
    vim[scope][setting] = value
  end
end

-- Diagnostics
vim.diagnostic.config {
  virtual_text = true,
}
