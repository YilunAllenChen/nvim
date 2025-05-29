-- LSP
local mason_servers = {
  pyright = {
    settings = {
      python = {
        analysis = {
          diagnosticMode = 'openFilesOnly',
          -- diagnosticMode = 'workspace',
        },
      },
    },
  },
}

-- servers not in mason yet
local raw_servers = {
  gleam = {},
}

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } },
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'mason-org/mason.nvim',
    event = 'VeryLazy',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'mason-org/mason-lspconfig.nvim',
    event = 'VeryLazy',
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(mason_servers),
        automatic_installation = false,
        automatic_enable = false,
      }
      for _, lsp in ipairs(vim.tbl_keys(raw_servers)) do
        require('lspconfig')[lsp].setup(raw_servers[lsp])
      end
      for server_name, server in pairs(mason_servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require('lspconfig')[server_name].setup(server)
      end
    end,
  },
  { 'jubnzv/virtual-types.nvim', event = { 'BufReadPre', 'BufNewFile' } },
}
