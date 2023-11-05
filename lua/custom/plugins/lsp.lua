-- LSP
return
{
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    {
      'nvim-lua/lsp-status.nvim',
      config = function()
        require 'lsp-status'.register_progress()
      end,
    },
    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    'folke/neodev.nvim',
  },
}
