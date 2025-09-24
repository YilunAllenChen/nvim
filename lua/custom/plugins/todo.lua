-- highlight todos, and find them with leader-f-d
return {
  'folke/todo-comments.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {},
  keys = {
    { '<leader>fd', function() require('snacks').picker.todo_comments() end, desc = 'Todo' },
  },
}
