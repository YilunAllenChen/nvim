return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose', 'Review' },
  opts = {
    enhanced_diff_hl = true,
  },
  config = function(_, opts)
    require('diffview').setup(opts)

    vim.api.nvim_create_user_command('Review', function()
      vim.cmd('DiffviewOpen')
      -- Open a terminal in a vertical split on the right
      vim.cmd('botright vsplit | terminal')
      vim.cmd('setlocal nonumber norelativenumber')
    end, {})
  end,
}
