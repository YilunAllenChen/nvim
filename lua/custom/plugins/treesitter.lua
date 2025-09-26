return { -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPre',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'python', 'lua', 'json', 'yaml' },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = { enable = false },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPre',
    config = function()
      require('treesitter-context').setup {
        enable = true,
        multiwindow = true,
        max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 2, -- Maximum number of lines to show for a single context
        trim_scope = 'outer',
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil,
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'BufReadPre',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter.configs').setup {
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<CR>',
            scope_incremental = '<C-CR>',
            node_incremental = '<CR>',
            node_decremental = '<BS>',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }
    end,
  },
  -- close html tags automatically using nvim-treesitter
  {
    'windwp/nvim-ts-autotag',
    event = 'BufReadPre',
    opts = {},
  },
}
