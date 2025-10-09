local mason_servers = {
  pyright = {
    settings = {
      python = {
        analysis = {
          diagnosticMode = 'openFilesOnly',
          indexing = true,
          autoImportCompletions = true,
          autoImportExclude = {
            '**/tests/**',
            '**/examples/**',
            '**/notebooks/**',
            '**/.benchmarks/**',
            '**/__pycache__/**',
          },
          exclude = {
            '**/tests/**',
            '**/examples/**',
            '**/notebooks/**',
            '**/.benchmarks/**',
            '**/__pycache__/**',
          },
        },
      },
    },
  },
}

-- servers not in mason yet
local raw_servers = {
  -- ty = {}  -- not stable yet...
}

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    event = 'BufReadPre',
    dependencies = {
      {
        'mason-org/mason.nvim',
        config = function() require('mason').setup() end,
        keys = {
          { '<leader>pm', '<cmd>Mason<cr>', desc = 'Mason Installer' },
        },
      },
      {
        'neovim/nvim-lspconfig',
      },
    },
    config = function()
      for server_name, server in pairs(raw_servers) do
        vim.lsp.enable(server_name)
      end

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      for server_name, server in pairs(mason_servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(server_name, server)
      end

      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(mason_servers),
        automatic_installation = false,
      }
    end,
  },
  { 'jubnzv/virtual-types.nvim', event = { 'BufReadPre', 'BufNewFile' } },
}
