-- display color codes in color
return {
  'brenoprata10/nvim-highlight-colors',
  config = function()
    vim.opt.termguicolors = true
    require('nvim-highlight-colors').setup {
      render = 'virtual',
      -- enable_tailwind = true,
    }
  end,
}
