return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  config = function()
    vim.keymap.set('i', '<Tab>', function()
      return vim.fn['codeium#Accept']()
    end, { expr = true, silent = true })
  end,
}
