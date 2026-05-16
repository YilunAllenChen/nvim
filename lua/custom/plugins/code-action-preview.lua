return {
  'aznhe21/actions-preview.nvim',
  event = 'LspAttach',
  keys = {
    { '<leader>la', function() require('actions-preview').code_actions() end, desc = 'Code action' },
  },
  config = function()
    require('actions-preview').setup {
      telescope = {
        sorting_strategy = 'ascending',
        layout_strategy = 'vertical',
        layout_config = {
          width = 0.5,
          height = 0.5,
          prompt_position = 'top',
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines) return max_lines - 15 end,
          mirror = true,
        },
      },
    }
  end,
}
