-- Reset foldexpr on terminal open
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.cmd 'set foldexpr&'
  end,
})

