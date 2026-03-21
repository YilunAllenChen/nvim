return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  keys = {
    { '<leader>fm', '<cmd>messages<cr>', desc = 'Messages' },
  },
  opts = {
    lsp = {
      override = { ['cmp.entry.get_documentation'] = false },
    },
    presets = { lsp_doc_border = true },
  },
  dependencies = { 'MunifTanjim/nui.nvim' },
}
