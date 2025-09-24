-- finder
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local pickers = require 'telescope.pickers'

RipGrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == '' then
        return nil
      end

      local pieces = vim.split(prompt, '  ')
      local args = { 'rg' }
      if pieces[1] then
        table.insert(args, '-e')
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        local fuzzy_pattern = '**/*' .. pieces[2] .. '*'
        table.insert(args, '-g')
        table.insert(args, fuzzy_pattern)
      end

      return vim
        .iter({
          args,
          { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' },
        })
        :flatten()
        :totable()
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers
    .new(opts, {
      prompt_title = 'RipGrep',
      finder = finder,
      debounce = 500,
    })
    :find()
end

return {
  'nvim-telescope/telescope.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      event = 'VeryLazy',
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
        prompt_prefix = string.format('%s ', '  '),
        selection_caret = string.format('%s ', '>'),
        path_display = { 'full' },
        preview = {
          filesize_limit = 1, -- in MB
        },
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
        layout_strategy = 'flex',
        layout_config = {
          horizontal = {
            prompt_position = 'top',
          },
          vertical = {
            prompt_position = 'top',
            preview_cutoff = 0,
            preview_height = 0.4,
            mirror = true,
          },
          width = 0.8,
          height = 0.8,
        },
        mappings = {
          i = { ['<esc>'] = require('telescope.actions').close },
          n = { ['q'] = require('telescope.actions').close },
        },
      },
      extensions = {
        fzf = {},
      },
    }
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'repo')
    pcall(require('telescope').load_extension, 'nerdy')
  end,

  keys = {

    {
      '<leader>lD',
      function()
        require('telescope.builtin').diagnostics()
      end,
      desc = 'Search diagnostics',
    },
    {
      '<leader>lG',
      function()
        require('telescope.builtin').lsp_workspace_symbols()
      end,
      desc = 'Search workspace symbols',
    },
    {
      '<leader>ls',
      function()
        require('telescope.builtin').lsp_document_symbols()
      end,
      desc = 'Search symbols',
    },

    {
      '<leader>f<CR>',
      function()
        require('telescope.builtin').resume()
      end,
      desc = 'Resume previous search',
    },
    {
      '<leader>fc',
      function()
        require('telescope.builtin').grep_string()
      end,
      desc = 'Find for word under cursor',
    },
    {
      '<leader>fn',
      function()
        require('telescope').extensions.notify.notify()
      end,
      desc = 'Find notifications',
    },
    {
      '<leader>fi',
      function()
        require('telescope').extensions.nerdy.nerdy()
      end,
      desc = 'Find icons',
    },
    {
      '<leader>fC',
      function()
        require('telescope.builtin').commands()
      end,
      desc = 'Find commands',
    },
    {
      '<leader>fh',
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = 'Find help',
    },
    {
      '<leader>fk',
      function()
        require('telescope.builtin').keymaps()
      end,
      desc = 'Find keymaps',
    },
    {
      '<leader>ft',
      function()
        require('telescope.builtin').colorscheme { enable_preview = true }
      end,
      desc = 'Find themes',
    },
    {
      '<leader>G',
      function()
        require('telescope.builtin').git_bcommits_range()
      end,
      desc = 'Git commits in buffer for selected range',
    },
  },
}
