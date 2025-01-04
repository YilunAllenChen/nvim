return {
  'stevearc/oil.nvim',
  event = 'VeryLazy',
  opts = {
    keymaps = {
      ['?'] = 'actions.show_help',
      ['<tab>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-r>'] = 'actions.refresh',
    },
  },
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
}
