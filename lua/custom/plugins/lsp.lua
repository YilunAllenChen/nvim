-- LSP
local mason_servers = {
  -- ['pyright@1.1.337'] = {},
  -- rust_analyzer = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs' } },

  -- lua_ls = {
  --   Lua = {
  --     workspace = { checkThirdParty = false },
  --     telemetry = { enable = false },
  --   },
  -- },
}

-- servers not in mason yet
local raw_servers = {
  gleam = {},
}

return {
  'folke/neodev.nvim',
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
        ensure_installed = vim.tbl_keys(mason_servers),
      }
      mlsp.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            settings = mason_servers[server_name],
            filetypes = (mason_servers[server_name] or {}).filetypes,
          }
        end,
      }

      local servers = vim.tbl_keys(raw_servers)
      for _, lsp in ipairs(servers) do
        require('lspconfig')[lsp].setup(raw_servers[lsp])
      end
    end,
  },
  {
    'nvim-lua/lsp-status.nvim',
    config = function()
      require('lsp-status').register_progress()
    end,
  },
  { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
  { 'jubnzv/virtual-types.nvim' },
}
