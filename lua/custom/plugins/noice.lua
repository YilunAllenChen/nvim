return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  opts = {
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
