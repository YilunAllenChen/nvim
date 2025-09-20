local M = {}

function M.which_key_register()
  if M.which_key_queue then
    local wk_avail, wk = pcall(require, 'which-key')
    if wk_avail then
      for mode, registration in pairs(M.which_key_queue) do
        wk.add(registration, { mode = mode })
      end
      M.which_key_queue = nil
    end
  end
end

function M.set_mappings(map_table, base)
  -- iterate over the first keys for each mode
  base = base or {}
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd = options
        local keymap_opts = base
        if type(options) == 'table' then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend('force', keymap_opts, options)
          keymap_opts[1] = nil
        end
        if not cmd or keymap_opts.name then -- if which-key mapping, queue it
          if not M.which_key_queue then
            M.which_key_queue = {}
          end
          if not M.which_key_queue[mode] then
            M.which_key_queue[mode] = {}
          end
          M.which_key_queue[mode][keymap] = keymap_opts
        else -- if not which-key mapping, set it
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
        end
      end
    end
  end
  if package.loaded['which-key'] then
    M.which_key_register()
  end -- if which-key is loaded already, register
end

local function delete_all_unused_bufs()
  -- Get list of all buffer numbers
  local bufnr_list = vim.api.nvim_list_bufs()

  -- Get list of all visible buffer numbers
  local visible_bufnrs = {}
  local windows = vim.api.nvim_list_wins()
  for _, win_id in ipairs(windows) do
    local open_bufnr = vim.api.nvim_win_get_buf(win_id)
    visible_bufnrs[open_bufnr] = true
  end

  for _, bufnr in ipairs(bufnr_list) do
    if vim.api.nvim_buf_get_option(bufnr, 'modified') then
      -- Skip the buffer if it has unsaved changes
      goto continue
    end
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    -- Check if buffer is NvimTree, terminal, or visible
    if not (string.match(bufname, 'NvimTree_') or string.match(bufname, 'term://') or visible_bufnrs[bufnr]) then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end

    ::continue::
  end
end

local function auto_activate_conda()
  local function get_last_part_of_path(path)
    return path:match '^.*/(.*)$'
  end
  -- Helper function to read the `.conda-env` file
  local function get_conda_env()
    local registry = {
      ['alsenal'] = 'alsenal',
      ['data'] = 'data',
      ['data-utils'] = 'du',
      ['desk-tools'] = 'desk-tools',
    }
    local current_path = vim.fn.getcwd()
    local last_part = get_last_part_of_path(current_path)

    return registry[last_part] or nil
  end

  local conda_env = get_conda_env()
  if conda_env then
    local term_cmd = string.format('conda activate %s; clear', conda_env)
    vim.fn.chansend(vim.b.terminal_job_id, term_cmd .. '\n')
  end
end

local function toggle_telescope_harpoon(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  local conf = require('telescope.config').values
  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Harpoon',
      finder = require('telescope.finders').new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

M.set_mappings {
  n = {

    -- Blazingly Fast Shortcuts
    ["'"] = {
      function()
        if vim.bo.buftype == 'terminal' then
          vim.cmd 'bd!'
        else
          vim.cmd 'confirm q'
        end
      end,
      desc = 'Quit',
    },
    [','] = {
      function()
        -- require('telescope.builtin').live_grep()
        RipGrep(opts)
      end,
      desc = 'Find words',
    },
    ['='] = {
      function()
        require('telescope.builtin').find_files()
      end,
      desc = 'Find all files',
    },
    ['<C-g>'] = {
      function()
        local filePath = vim.fn.expand '%:p'
        if filePath == '' then
          print 'No file loaded'
        else
          print(filePath)
        end
      end,
      desc = 'Show Full Path',
    },

    -- Jumping Around
    [';'] = { '<cmd>:HopWord<cr>', desc = 'Hop' },
    ['<leader>s'] = {
      function()
        require('telescope.builtin').current_buffer_fuzzy_find()
      end,
      desc = 'Fuzzy Search In Buffer',
    },
    ['gd'] = {
      function()
        require('telescope.builtin').lsp_definitions()
      end,
      desc = 'definition',
    },
    ['gD'] = {
      function()
        require('telescope.builtin').lsp_declarations()
      end,
      desc = 'Declaration of current symbol',
    },
    ['gr'] = {
      function()
        require('telescope.builtin').lsp_references()
      end,
      desc = 'references',
    },
    ['gt'] = {
      function()
        require('telescope.builtin').lsp_type_definitions()
      end,
      desc = 'type definition',
    },
    ['gI'] = {
      function()
        vim.lsp.buf.implementation()
      end,
      desc = 'implementation',
    },
    ['<leader>ha'] = {
      function()
        local harpoon = require 'harpoon'
        harpoon:list():add()
      end,
      desc = 'Harpoon Add',
    },
    ['<leader>hd'] = {
      function()
        local harpoon = require 'harpoon'
        harpoon:list():delete()
      end,
      desc = 'Harpoon Delete',
    },
    ['<leader>hp'] = {
      function()
        local harpoon = require 'harpoon'
        toggle_telescope_harpoon(harpoon:list())
      end,
      desc = 'Harpoon Find',
    },
    ['<leader>i'] = {
      function()
        require('telescope').extensions.repo.list { search_dirs = { '~/repos/' } }
      end,
      desc = 'Open project',
    },

    ['<leader>o'] = { '<cmd>:Oil<cr>', desc = 'Oil' },
    ['<leader>j'] = {
      function()
        require('telescope.builtin').buffers()
      end,
      desc = 'Find buffers',
    },

    -- Editing
    ['gx'] = { "<cmd>:execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>", desc = 'open file under cursor' },
    ['gz'] = { '<cmd>:e <cfile><CR>', desc = 'open file under cursor' },
    ['<leader>e'] = { '<cmd>NvimTreeToggle<cr>', desc = 'Explorer' },
    ['<leader>w'] = { '<cmd>w<cr>', desc = 'Save' },
    ['<leader>q'] = { '<cmd>confirm q<cr>', desc = 'Quit' },
    ['<leader>n'] = { '<cmd>enew<cr>', desc = 'New File' },
    ["<leader>'"] = { '<cmd>:edit!<cr>', desc = 'Reload buffer' },
    ['<leader>/'] = {
      function()
        require('Comment.api').toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1)
      end,
      desc = 'Toggle comment line',
    },
    ['<leader>r'] = {
      function()
        require('grug-far').open()
      end,
      desc = 'search & replace',
    },

    -- Packages & Plugins
    ['<leader>pp'] = {
      function()
        require('lazy').home()
      end,
      desc = 'Plugins',
    },
    ['<leader>pm'] = { '<cmd>Mason<cr>', desc = 'Mason Installer' },

    -- Git
    [']g'] = {
      function()
        require('gitsigns').nav_hunk 'next'
      end,
      desc = 'Next Git hunk',
    },
    ['[g'] = {
      function()
        require('gitsigns').nav_hunk 'prev'
      end,
      desc = 'Previous Git hunk',
    },
    ['<leader>k'] = {
      function()
        require('gitsigns').blame_line { full = true }
      end,
      desc = 'View full Git blame',
    },
    ['<leader>g'] = {
      '<cmd>:LazyGit<cr>',
      desc = 'lazygit',
    },
    ['<leader>G'] = {
      function()
        require('telescope.builtin').git_bcommits()
      end,
      desc = 'Git commits in buffer',
    },
    -- LSP
    ['K'] = {
      function()
        vim.lsp.buf.hover { border = 'rounded' }
      end,
      desc = 'Hover symbol details',
    },
    ['<leader>d'] = {
      function()
        require('neogen').generate()
      end,
      desc = 'Generate documentation',
    },
    ['<leader>l'] = { desc = 'LSP' },
    ['<leader>lf'] = {
      function()
        vim.lsp.buf.format()
      end,
      desc = 'Format buffer',
    },
    ['<leader>lr'] = {
      function()
        vim.lsp.buf.rename()
        vim.cmd 'silent! wa'
      end,
      desc = 'Rename current symbol',
    },
    ['<leader>lx'] = { '<cmd>:LspRestart<cr>', desc = 'LSP Restart' },
    ['<leader>lG'] = {
      function()
        require('telescope.builtin').lsp_workspace_symbols()
      end,
      desc = 'Search workspace symbols',
    },
    ['<leader>ls'] = {
      function()
        require('telescope.builtin').lsp_document_symbols()
      end,
      desc = 'Search symbols',
    },
    ['<leader>la'] = {
      function()
        require('actions-preview').code_actions()
      end,
      desc = 'Code action',
    },
    ['<leader>lI'] = { '<cmd>LspInfo<cr>', desc = 'LSP information' },
    ['<leader>ld'] = {
      function()
        vim.diagnostic.open_float { border = 'rounded' }
      end,
      desc = 'Hover diagnostics',
    },
    ['<leader>lD'] = {
      function()
        require('telescope.builtin').diagnostics()
      end,
      desc = 'Search diagnostics',
    },
    ['<leader>li'] = {
      function()
        local clients = vim.lsp.get_clients()
        if clients == nil or clients[1] == nil then
          return
        end
        local client = clients[1]
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
        end
      end,
      desc = 'Enable inlay hints',
    },
    ['[d'] = {
      function()
        vim.diagnostic.get_prev()
      end,
      desc = 'Previous diagnostic',
    },
    [']d'] = {
      function()
        vim.diagnostic.get_next()
      end,
      desc = 'Next diagnostic',
    },

    -- DAP
    ['<space>b'] = {
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Toggle breakpoint',
    },
    ['<space>?'] = {
      function()
        require('dapui').eval(nil, { enter = true })
      end,
      desc = 'Evaluate expression',
    },
    ['<F1>'] = {
      function()
        require('dap').continue()
      end,
      desc = 'Continue',
    },
    ['<F2>'] = {
      function()
        require('dap').step_into()
      end,
      desc = 'Step into',
    },
    ['<F3>'] = {
      function()
        require('dap').step_over()
      end,
      desc = 'Step over',
    },
    ['<F4>'] = {
      function()
        require('dap').step_out()
      end,
      desc = 'Step out',
    },
    ['<F5>'] = {
      function()
        require('dap').step_back()
      end,
      desc = 'Step back',
    },
    ['<F11>'] = {
      function()
        require('dap').close()
      end,
      desc = 'Stop',
    },
    ['<F12>'] = {
      function()
        require('dap').restart()
      end,
      desc = 'Restart',
    },

    -- Buffers
    ['H'] = { '<cmd>:bprevious<cr>', desc = 'Prev Buffer' },
    ['L'] = { '<cmd>:bnext<cr>', desc = 'Next Buffer' },
    ['<leader>C'] = { delete_all_unused_bufs, desc = 'Close all buffers except for tree & terminals current' },

    ['<leader>c'] = { ':bnext<CR>:bd#<CR>', desc = 'Close buffer' },

    -- Findings stuff
    ['<leader>f'] = { desc = 'Find' },
    ['<leader>fd'] = { '<cmd>TodoTelescope<cr>', desc = 'TODO' },
    ['<leader>f<CR>'] = {
      function()
        require('telescope.builtin').resume()
      end,
      desc = 'Resume previous search',
    },
    ['<leader>fc'] = {
      function()
        require('telescope.builtin').grep_string()
      end,
      desc = 'Find for word under cursor',
    },
    ['<leader>fn'] = {
      function()
        require('telescope').extensions.notify.notify()
      end,
      desc = 'Find notifications',
    },
    ['<leader>fi'] = {
      function()
        require('telescope').extensions.nerdy.nerdy()
      end,
      desc = 'Find icons',
    },
    ['<leader>fC'] = {
      function()
        require('telescope.builtin').commands()
      end,
      desc = 'Find commands',
    },
    ['<leader>fh'] = {
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = 'Find help',
    },
    ['<leader>fk'] = {
      function()
        require('telescope.builtin').keymaps()
      end,
      desc = 'Find keymaps',
    },
    ['<leader>ft'] = {
      function()
        require('telescope.builtin').colorscheme { enable_preview = true }
      end,
      desc = 'Find themes',
    },

    -- Opening terminals
    ['<C-t>'] = {
      function()
        vim.api.nvim_command 'terminal'
        auto_activate_conda()
        vim.cmd 'startinsert'
      end,
    },
    ['<leader>t'] = {
      function()
        vim.api.nvim_command 'vsplit | terminal codex'
        vim.api.nvim_command 'startinsert'
        auto_activate_conda()
      end,
      desc = 'Open codex in vertical split',
    },
    ['t'] = {
      function()
        vim.api.nvim_command '25split | terminal'
        auto_activate_conda()
        vim.cmd 'startinsert'
      end,
    },
    ['T'] = {
      function()
        vim.api.nvim_command 'vsplit | terminal'
        auto_activate_conda()
        vim.cmd 'startinsert'
      end,
    },
    -- window management & navigation
    ['\\'] = { '<C-w>v', desc = 'Vertical Split' },
    ['-'] = { '<C-w>s', desc = 'Horizontal Split' },

    ['<C-Left>'] = {
      function()
        require('smart-splits').resize_left()
      end,
      desc = 'resize_left',
    },
    ['<C-Down>'] = {
      function()
        require('smart-splits').resize_down()
      end,
      desc = 'resize_down',
    },
    ['<C-Up>'] = {
      function()
        require('smart-splits').resize_up()
      end,
      desc = 'resize_up',
    },
    ['<C-Right>'] = {
      function()
        require('smart-splits').resize_right()
      end,
      desc = 'resize_right',
    },
    -- moving between splits
    ['<C-h>'] = {
      function()
        require('smart-splits').move_cursor_left()
      end,
      desc = 'move_cursor_left',
    },
    ['<C-j>'] = {
      function()
        require('smart-splits').move_cursor_down()
      end,
      desc = 'move_cursor_down',
    },
    ['<C-k>'] = {
      function()
        require('smart-splits').move_cursor_up()
      end,
      desc = 'move_cursor_up',
    },
    ['<C-l>'] = {
      function()
        require('smart-splits').move_cursor_right()
      end,
      desc = 'move_cursor_right',
    },
    -- swapping buffers between windows
    ['<leader><leader>h'] = {
      function()
        require('smart-splits').swap_buf_left()
      end,
      desc = 'swap_buf_left',
    },
    ['<leader><leader>j'] = {
      function()
        require('smart-splits').swap_buf_down()
      end,
      desc = 'swap_buf_down',
    },
    ['<leader><leader>k'] = {
      function()
        require('smart-splits').swap_buf_up()
      end,
      desc = 'swap_buf_up',
    },
    ['<leader><leader>l'] = {
      function()
        require('smart-splits').swap_buf_right()
      end,
      desc = 'swap_buf_right',
    },

    ['<leader><leader>c'] = { '<cmd>e ~/.config/fish/config.fish<cr>', desc = 'Edit fish config' },
    -- fun stuff
    ['<leader>fml'] = { '<cmd>CellularAutomaton make_it_rain<cr>', desc = 'Make It Rain!!!' },
    ['<leader>fmg'] = { '<cmd>CellularAutomaton game_of_life<cr>', desc = 'Game Of Life!!!' },
    ['<leader>fms'] = { '<cmd>CellularAutomaton scramble<cr>', desc = 'SCRABLE!!!' },

    -- space as text object
    ['ci<space>'] = { '<esc>bvt c', desc = 'Change inside surrounding spaces' },
    ['di<space>'] = { '<esc>bvt d', desc = 'Delete inside surrounding spaces' },
    ['vi<space>'] = { '<esc>bvt ', desc = 'Select inside surrounding spaces' },
    ['yi<space>'] = { '<esc>bvt y', desc = 'Yank inside surrounding spaces' },

    ['<leader>q'] = { desc = 'Sessions' },
    ['<leader>qs'] = {
      function()
        require('persistence').load()
      end,
      desc = 'load session for current dir',
    },
    ['<leader>qS'] = {
      function()
        require('persistence').seldct()
      end,
      desc = 'select session',
    },
    ['<leader>ql'] = {
      function()
        require('persistence').load { last = true }
      end,
      desc = 'load last session',
    },
  },
  t = {
    ['<esc>'] = { '<C-\\><C-n>' },
    ['<C-BS>'] = { '<C-w>', desc = 'Delete word' },
    ['<C-j>'] = { '<cmd>wincmd j<cr>', desc = 'Terminal down window navigation' },
    ['<C-k>'] = { '<cmd>wincmd k<cr>', desc = 'Terminal up window navigation' },
    ['<C-h>'] = { '<cmd>wincmd h<cr>', desc = 'Terminal left window navigation' },
    ['<C-l>'] = { '<cmd>wincmd l<cr>', desc = 'Terminal right window navigation' },
  },
  i = {
    ['<C-z>'] = { '<esc>ui', desc = 'Undo' },
    ['<C-h>'] = { '<left>', desc = 'Move left' },
    ['<C-l>'] = { '<right>', desc = 'Move right' },
    ['<C-j>'] = { '<down>', desc = 'Move down' },
    ['<C-k>'] = { '<up>', desc = 'Move up' },
    ['<C-n>'] = { '<backspace>', desc = 'backspace' },
    ['<C-s>'] = { '<cmd>:w<cr><esc>', desc = 'Save file' },
    ['<C-e>'] = { '<esc>ldwi', desc = 'Erase word Forward' },
    ['<C-v>'] = { '<esc>pi', desc = 'Paste' },
  },
  v = {
    ['<leader>/'] = {
      "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
      desc = 'Toggle comment for selection',
    },
    ['<S-Tab>'] = { '<gv', desc = 'Unindent line' },
    ['<Tab>'] = { '>gv', desc = 'Indent line' },
    ['<leader>G'] = {
      function()
        require('telescope.builtin').git_bcommits_range()
      end,
      desc = 'Git commits in buffer for selected range',
    },
  },
}
