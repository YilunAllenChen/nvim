-- nvim v0.7.2
return {
  'kdheepak/lazygit.nvim',
  -- optional for floating window border decoration
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>g', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },
}
