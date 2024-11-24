return {
  'Exafunction/codeium.vim',
  -- tag = '1.4.15',
  event = 'BufEnter',
  config = function()
    vim.keymap.set('i', '<Right>', function()
      return vim.fn['codeium#Accept']()
    end, { expr = true, silent = true })
  end,
}
