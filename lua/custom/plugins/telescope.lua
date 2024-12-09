-- finder
return {
  'nvim-telescope/telescope.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  opts = {},
  config = function()
    require('telescope').setup {
      defaults = {
        prompt_prefix = string.format('%s ', '/'),
        selection_caret = string.format('%s ', '>'),
        path_display = { 'full' },
        file_ignore_patterns = {
          'node_modules',
          '.mypy_cache',
          '.pyc',
          '*.git$',
          '^.git/*',
          '.pytest_cache',
          'target/',
          '**/dist',
          '**/test_recorder',
          'build/',
          '^.cargo/*',
          '^.rustup/*',
        },
        sorting_strategy = 'ascending',
        layout_strategy = 'vertical',
        layout_config = {
          vertical = {
            prompt_position = 'top',
            preview_cutoff = 0,
            preview_height = 0.3,
            mirror = true,
          },
          width = 0.8,
          height = 0.8,
        },
        mappings = {
          i = {
            ['<esc>'] = require('telescope.actions').close,
          },
          n = { ['q'] = require('telescope.actions').close },
        },
      },
    }
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'projects')
  end,
}
