-- LSP
local servers = {
  ['pyright@1.1.337'] = {},
  rust_analyzer = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

return {
  'folke/neodev.nvim',

  {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup {
        sources = {
          -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#formatting
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
        },
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
  },
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('neodev').setup()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      local mlsp = require 'mason-lspconfig'
      mlsp.setup {
        ensure_installed = vim.tbl_keys(servers),
      }
      mlsp.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          }
        end,
      }
    end,
  },
  {
    'nvim-lua/lsp-status.nvim',
    config = function()
      require('lsp-status').register_progress()
    end,
  },
  { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    },
    opts = {
      ensure_installed = {},
      handlers = {},
    },
  },
}
