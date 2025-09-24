return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    input = { enabled = true },
    explorer = {},
    gitbrowse = {
      enabled = true,
      notify = true,
      what = 'permalink',
      url_patterns = {
        ['git.drwholdings.com'] = {
          branch = '/tree/{branch}',
          file = '/blob/{branch}/{file}#L{line_start}-L{line_end}',
          permalink = '/blob/{commit}/{file}#L{line_start}-L{line_end}',
          commit = '/commit/{commit}',
        },
      },
    },
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            ['<c-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
            ['<c-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
          },
        },
      },
      previewers = {
        file = {
          max_line_length = 2000,
        },
      },
      matcher = {
        cwd_bonus = true,
        frecency = true,
      },
      formatters = {
        file = {
          truncate = 80, -- truncate the file path to (roughly) this length
        },
      },
      sources = {
        explorer = {
          matcher = { fuzzy = true },
          win = {
            list = {
              keys = {
                ['<BS>'] = 'explorer_up',
                ['l'] = 'confirm',
                ['h'] = 'explorer_close', -- close directory
                ['a'] = 'explorer_add',
                ['d'] = 'explorer_del',
                ['r'] = 'explorer_rename',
                ['c'] = 'explorer_copy',
                ['m'] = 'explorer_move',
                ['o'] = 'explorer_open', -- open with system application
                ['y'] = { 'explorer_yank', mode = { 'n', 'x' } },
                ['p'] = 'explorer_paste',
                ['u'] = 'explorer_update',
                ['K'] = 'inspect',
                ['<c-c>'] = 'tcd',
                ['.'] = 'explorer_focus',
                ['I'] = 'toggle_ignored',
                ['H'] = 'toggle_hidden',
                ['Z'] = 'explorer_close_all',
              },
            },
          },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true },
      },
    },
    statuscolumn = { enabled = true, left = { 'git' }, right = {}, refresh = 500 },
  },
  keys = {
    -- -- Top Pickers & Explorer
    { '=', function() require('snacks').picker.smart() end, desc = 'Smart Find Files' },
    { ',', function() require('snacks').picker.grep() end, desc = 'Grep' },
    -- -- find
    { '<leader>j', function() require('snacks').picker.buffers() end, desc = 'Buffers' },
    { '<leader>i', function() require('snacks').picker.projects() end, desc = 'Projects' },
    { '<leader>e', function() require('snacks').explorer() end, desc = 'Explorer' },
    {
      '<leader>y',
      function()
        require('snacks').gitbrowse { open = function(url) vim.fn.setreg('+', url) end }
      end,
      desc = 'Gitbrowse',
      mode = { 'n', 'v' },
    },
    { '<leader>Y', function() require('snacks').gitbrowse() end, desc = 'Gitbrowse', mode = { 'n', 'v' } },
    -- -- git
    { '<leader>Gl', function() require('snacks').picker.git_log() end, desc = 'Git Log' },
    { '<leader>k', function() require('snacks').picker.git_log_line() end, desc = 'Git Log Line' },
    { '<leader>Gf', function() require('snacks').picker.git_log_file() end, desc = 'Git Log File' },
    -- -- search
    { '<leader>fc', function() require('snacks').picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' } },
    { '<leader>fC', function() require('snacks').picker.commands() end, desc = 'Command History' },
    { '<leader>lD', function() require('snacks').picker.diagnostics() end, desc = 'Diagnostics' },
    { '<leader>fh', function() require('snacks').picker.help() end, desc = 'Help Pages' },
    { '<leader>fi', function() require('snacks').picker.icons() end, desc = 'Icons' },
    { '<leader>fk', function() require('snacks').picker.keymaps() end, desc = 'Keymaps' },
    { '<leader>f<CR>', function() require('snacks').picker.resume() end, desc = 'Resume previous search' },
    { '<leader>ft', function() require('snacks').picker.colorschemes() end, desc = 'Colorschemes' },
    -- -- LSP
    { 'gd', function() require('snacks').picker.lsp_definitions() end, desc = 'Goto Definition' },
    { 'gD', function() require('snacks').picker.lsp_declarations() end, desc = 'Goto Declaration' },
    { 'gr', function() require('snacks').picker.lsp_references() end, nowait = true, desc = 'References' },
    { 'gI', function() require('snacks').picker.lsp_implementations() end, desc = 'Goto Implementation' },
    { 'gy', function() require('snacks').picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition' },
    { '<leader>ls', function() require('snacks').picker.lsp_symbols() end, desc = 'LSP Symbols' },
    { '<leader>lG', function() require('snacks').picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols' },
    { '<leader>fn', function() require('snacks').picker.notifications() end, desc = 'Notification History' },
    { '<leader>g', function() require('snacks').lazygit() end, desc = 'Lazygit' },
  },
}
