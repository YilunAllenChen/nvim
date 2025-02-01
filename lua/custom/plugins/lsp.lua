-- LSP
local mason_servers = {
  pyright = {},
  ['rust_analyzer@2024-10-21'] = {},
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
    event = { 'BufReadPre', 'BufNewFile' },
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
      local mlsp = require 'mason-lspconfig'
      mlsp.setup {
        ensure_installed = vim.tbl_keys(mason_servers),
      }
      mlsp.setup_handlers {
        function(server_name)
          capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
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
