local function toggle_explorer()
  local snacks = require 'snacks'
  local explorers = snacks.picker.get { source = 'explorer' }

  if #explorers > 0 then
    for _, picker in ipairs(explorers) do
      picker:close()
    end
    return
  end

  snacks.explorer.reveal()
end

local alpha_hl_map = {
  a = 'AlphaA',
  b = 'AlphaB',
  g = 'AlphaG',
  h = 'AlphaH',
  i = 'AlphaI',
  j = 'AlphaJ',
  k = 'AlphaK',
}

local function set_dashboard_highlights()
  vim.api.nvim_set_hl(0, 'SnacksPickerDir', { fg = 'none', nocombine = true })
  vim.api.nvim_set_hl(0, 'AlphaB', { fg = '#3399ff', ctermfg = 33 })
  vim.api.nvim_set_hl(0, 'AlphaA', { fg = '#53C670', ctermfg = 35 })
  vim.api.nvim_set_hl(0, 'AlphaG', { fg = '#39ac56', ctermfg = 29 })
  vim.api.nvim_set_hl(0, 'AlphaH', { fg = '#33994d', ctermfg = 23 })
  vim.api.nvim_set_hl(0, 'AlphaI', { fg = '#33994d', bg = '#39ac56', ctermfg = 23, ctermbg = 29 })
  vim.api.nvim_set_hl(0, 'AlphaJ', { fg = '#53C670', bg = '#33994d', ctermfg = 35, ctermbg = 23 })
  vim.api.nvim_set_hl(0, 'AlphaK', { fg = '#30A572', ctermfg = 36 })
end

local function dashboard_line(text, colormap)
  local segments = {}
  local current = { text = '', hl = nil }
  local len = vim.fn.strchars(text)

  for i = 0, len - 1 do
    local char = vim.fn.strcharpart(text, i, 1)
    local key = colormap:sub(i + 1, i + 1)
    local hl = alpha_hl_map[key]

    if current.text ~= '' and current.hl ~= hl then
      local segment = { current.text }
      if current.hl then segment.hl = current.hl end
      table.insert(segments, segment)
      current = { text = '', hl = hl }
    elseif current.text == '' then
      current.hl = hl
    end
    current.text = current.text .. char
  end

  if current.text ~= '' then
    local segment = { current.text }
    if current.hl then segment.hl = current.hl end
    table.insert(segments, segment)
  end

  return segments
end

local function build_dashboard_header()
  local lines = {
    { '  ███       ███  ', '  kkkka       gggg  ' },
    { '  ████      ████ ', '  kkkkaa      ggggg ' },
    { '  ████     █████ ', ' b kkkaaa     ggggg ' },
    { ' █ ████    █████ ', ' bb kkaaaa    ggggg ' },
    { ' ██ ████   █████ ', ' bbb kaaaaa   ggggg ' },
    { ' ███ ████  █████ ', ' bbbb aaaaaa  ggggg ' },
    { ' ████ ████ ████ ', ' bbbbb aaaaaa igggg ' },
    { ' █████  ████████ ', ' bbbbb  aaaaaahiggg ' },
    { ' █████   ███████ ', ' bbbbb   aaaaajhigg ' },
    { ' █████    ██████ ', ' bbbbb    aaaaajhig ' },
    { ' █████     █████ ', ' bbbbb     aaaaajhi ' },
    { ' ████      ████ ', ' bbbbb      aaaaajh ' },
    { '  ███       ███  ', '  bbbb       aaaaa  ' },
    { '                    ', '                    ' },
    { '                    ', '                    ' },
    { "    Allen's Neovim  ", '  aaaaaaaaabbbbbbb  ' },
    { ' ', ' ' },
    { ' ', ' ' },
    { ' ', ' ' },
  }
  local header = {}
  for i, line in ipairs(lines) do
    vim.list_extend(header, dashboard_line(line[1], line[2]))
    if i < #lines then table.insert(header, { '\n' }) end
  end
  return { text = header, align = 'center' }
end

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = set_dashboard_highlights,
})
set_dashboard_highlights()

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        build_dashboard_header(),
        { section = 'startup' },
      },
    },
    input = { enabled = true },
    notifier = { enabled = true },
    rename = { enabled = true },
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
      main = { file = false },
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
        files = {
          hidden = true,
          ignored = false,
        },
        explorer = {
          hidden = false,
          ignored = true,
          follow_file = true,
          win = {
            list = {
              keys = {
                ['/'] = false,
              },
            },
          },
          layout = {
            preset = 'sidebar',
            preview = false,
            layout = {
              width = 50,
              min_width = 50,
            },
          },
        },
        projects = {
          dev = { '~/dev', '~/projects', '~/repos' },
          layout = {
            preset = 'vscode',
          },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    styles = {
      notification = {
        border = 'rounded',
        wo = { wrap = true },
      },
    },
    -- statuscolumn = { enabled = true, left = { 'git' }, right = { 'sign' }, refresh = 500 },
  },
  keys = {
    -- -- Top Pickers & Explorer
    { '<leader>e', toggle_explorer, desc = 'File Explorer' },
    { '<leader>E', function() require('snacks').explorer.reveal() end, desc = 'Reveal File In Explorer' },
    { '=', function() require('snacks').picker.files() end, desc = 'Find Files' },
    { ',', function() require('snacks').picker.grep() end, desc = 'Grep' },
    -- -- find
    { '<leader>j', function() require('snacks').picker.buffers() end, desc = 'Buffers' },
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
    { '<leader>fC', function() require('snacks').picker.commands() end, desc = 'Commands' },
    { '<leader>lD', function() require('snacks').picker.diagnostics() end, desc = 'Diagnostics' },
    { '<leader>i', function() require('snacks').picker.projects() end, desc = 'Projects' },
    { '<leader>fh', function() require('snacks').picker.help() end, desc = 'Help Pages' },
    { '<leader>fi', function() require('snacks').picker.icons() end, desc = 'Icons' },
    { '<leader>fk', function() require('snacks').picker.keymaps() end, desc = 'Keymaps' },
    { '<leader>f<CR>', function() require('snacks').picker.resume() end, desc = 'Resume previous search' },
    { '<leader>ft', function() require('snacks').picker.colorschemes() end, desc = 'Colorschemes' },
    { '<leader>rf', function() require('snacks').rename.rename_file() end, desc = 'Rename file' },
    -- -- LSP
    { 'gd', function() require('snacks').picker.lsp_definitions() end, desc = 'Goto Definition' },
    { 'gD', function() require('snacks').picker.lsp_declarations() end, desc = 'Goto Declaration' },
    { 'gr', function() require('snacks').picker.lsp_references() end, nowait = true, desc = 'References' },
    { 'gI', function() require('snacks').picker.lsp_implementations() end, desc = 'Goto Implementation' },
    { 'gt', function() require('snacks').picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition' },
    { '<leader>ls', function() require('snacks').picker.lsp_symbols() end, desc = 'LSP Symbols' },
    { '<leader>lG', function() require('snacks').picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols' },
    { '<leader>fn', function() require('snacks').picker.notifications() end, desc = 'Notification History' },
    { '<leader>g', function() require('snacks').lazygit() end, desc = 'Lazygit' },
    { '<C-z>', function() require('snacks').picker.undo() end, desc = 'Undo' },
    { '<Tab>', function() require('snacks').picker.git_status() end, desc = 'Git Status' },
  },
}
