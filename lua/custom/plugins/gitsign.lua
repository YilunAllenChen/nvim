-- gitsign
return {
  'lewis6991/gitsigns.nvim',
  event = "BufEnter",
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
    end,
  },
}
