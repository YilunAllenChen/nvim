local mason_servers = {
  'prettier@3.0.2',
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
    on_attach = function(client, bufnr)
      -- Diagnostics only - disable all other capabilities
      local caps = client.server_capabilities
      caps.completionProvider = nil
      caps.hoverProvider = nil
      caps.signatureHelpProvider = nil
      caps.definitionProvider = nil
      caps.typeDefinitionProvider = nil
      caps.implementationProvider = nil
      caps.declarationProvider = nil
      caps.referencesProvider = nil
      caps.documentHighlightProvider = nil
      caps.documentSymbolProvider = nil
      caps.workspaceSymbolProvider = nil
      caps.codeActionProvider = nil
      caps.documentFormattingProvider = nil
      caps.documentRangeFormattingProvider = nil
      caps.renameProvider = nil
      caps.inlayHintProvider = nil
    end,
  },
  ty = {},
}

-- servers not in mason yet
local raw_servers = {}

local mason_tools = {
  { 'prettier', version = '3.0.2' },
}

local function setup_mason() require('mason').setup() end

local function setup_mason_lspconfig()
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
    automatic_installation = true,
  }
end

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } },
  },
  {
    'mason-org/mason.nvim',
    cmd = 'Mason',
    keys = {
      { '<leader>pm', '<cmd>Mason<cr>', desc = 'Mason Installer' },
    },
    config = setup_mason,
  },
  {
    'mason-org/mason-lspconfig.nvim',
    event = 'BufReadPre',
    dependencies = {
      'mason-org/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    config = setup_mason_lspconfig,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    event = 'BufReadPre',
    dependencies = {
      'mason-org/mason.nvim',
    },
    opts = {
      ensure_installed = mason_tools,
      run_on_start = true,
    },
  },
  { 'jubnzv/virtual-types.nvim', event = { 'BufReadPre', 'BufNewFile' } },
}
