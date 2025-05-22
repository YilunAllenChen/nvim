-- LSP
local mason_servers = {
  lua_ls = {},
}

-- servers not in mason yet
local raw_servers = {
  gleam = {},
}

return {
  'folke/neodev.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'williamboman/mason.nvim',
    event = 'VeryLazy',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('neodev').setup()
      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(mason_servers),
      }
      for _, lsp in ipairs(vim.tbl_keys(raw_servers)) do
        require('lspconfig')[lsp].setup(raw_servers[lsp])
      end
    end,
  },
  {
    'nvim-lua/lsp-status.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local status = require 'lsp-status'
      status.register_progress()
      status.config {
        status_symbol = '',
        diagnostics = false,
      }
    end,
  },
  { 'jubnzv/virtual-types.nvim', event = { 'BufReadPre', 'BufNewFile' } },
}
