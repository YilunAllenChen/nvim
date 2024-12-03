return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {},
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  config = {
    presets = {
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    lsp = {
      hover = {
        enabled = false,
      },
    },
  },
}
