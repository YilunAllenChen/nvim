local M = {}

local function nav_changed_file(direction)
  local cwd = vim.fn.getcwd()
  local lines = vim.fn.systemlist 'git status --porcelain 2>/dev/null'
  local files = {}
  for _, line in ipairs(lines) do
    local f = line:sub(4) -- skip "XY " status prefix
    if f ~= '' then table.insert(files, cwd .. '/' .. f) end
  end
  if #files == 0 then return end

  local current = vim.fn.expand '%:p'
  local idx = nil
  for i, f in ipairs(files) do
    if f == current then
      idx = i
      break
    end
  end

  local next_idx
  if idx == nil then
    next_idx = direction == 'next' and 1 or #files
  elseif direction == 'next' then
    next_idx = idx % #files + 1
  else
    next_idx = (idx - 2) % #files + 1
  end
  vim.cmd('edit ' .. vim.fn.fnameescape(files[next_idx]))
end

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
  base = base or {}
  for mode, maps in pairs(map_table) do
    for keymap, options in pairs(maps) do
      if options then
        local cmd = options
        local keymap_opts = base
        if type(options) == 'table' then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend('force', keymap_opts, options)
          keymap_opts[1] = nil
        end
        if not cmd or keymap_opts.name then -- if which-key mapping, queue it
          if not M.which_key_queue then M.which_key_queue = {} end
          if not M.which_key_queue[mode] then M.which_key_queue[mode] = {} end
          M.which_key_queue[mode][keymap] = keymap_opts
        else -- if not which-key mapping, set it
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
        end
      end
    end
  end
  if package.loaded['which-key'] then M.which_key_register() end -- if which-key is loaded already, register
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
    if vim.api.nvim_get_option_value('modified', { buf = bufnr }) then goto continue end
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if not (string.match(bufname, 'term://') or visible_bufnrs[bufnr]) then vim.api.nvim_buf_delete(bufnr, { force = true }) end
    ::continue::
  end
end

local function goto_tab(index)
  if index < 1 then return end

  local tabs = vim.api.nvim_list_tabpages()
  local tab_count = #tabs

  if index > tab_count then -- create tabs until the requested index exists
    for _ = 1, index - tab_count do
      vim.cmd 'tabnew'
      local initial_buf = vim.api.nvim_get_current_buf()
      local alpha_ok = pcall(vim.cmd, 'Alpha')
      if alpha_ok then
        local alpha_buf = vim.api.nvim_get_current_buf()
        if alpha_buf ~= initial_buf and vim.api.nvim_buf_is_valid(initial_buf) then
          local name = vim.api.nvim_buf_get_name(initial_buf)
          local buftype = vim.api.nvim_get_option_value('buftype', { buf = initial_buf })
          if name == '' and buftype == '' then vim.api.nvim_buf_delete(initial_buf, { force = true }) end
        end
      end
    end
    tabs = vim.api.nvim_list_tabpages()
  end

  local tab = tabs[index]
  if tab then
    vim.api.nvim_set_current_tabpage(tab)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = 0 })
    if buftype == 'terminal' then vim.cmd 'startinsert' end
  end
end

local last_ai_buf

local function open_ai_terminal(resume)
  local ai_priority = { 'pi', 'claude', 'codex' }
  local ai_command
  for _, cmd in ipairs(ai_priority) do
    if vim.fn.executable(cmd) == 1 then
      ai_command = cmd
      break
    end
  end

  if not ai_command then
    vim.notify(('None of %s are installed'):format(table.concat(ai_priority, ', ')), vim.log.levels.ERROR)
    return
  end

  local args = { ai_command }
  if ai_command == 'claude' then
    table.insert(args, '--permission-mode')
    table.insert(args, 'acceptEdits')
    if resume then table.insert(args, '-r') end
  elseif resume then
    table.insert(args, '-r')
  end

  local terminal_cmd = 'terminal ' .. table.concat(args, ' ')
  if vim.bo.filetype == 'alpha' or vim.bo.filetype == 'snacks_dashboard' then
    vim.api.nvim_command(terminal_cmd)
  else
    vim.api.nvim_command('vsplit | ' .. terminal_cmd)
  end
  vim.api.nvim_command 'startinsert'
  last_ai_buf = vim.api.nvim_get_current_buf()
end

local function copy_location_to_ai()
  if vim.bo.buftype ~= '' then
    vim.notify('Current buffer is not a file', vim.log.levels.ERROR)
    return
  end

  local location = ('%s:%d'):format(vim.fn.expand '%:p', vim.fn.line '.')
  vim.fn.setreg('+', location)

  if not last_ai_buf or not vim.api.nvim_buf_is_valid(last_ai_buf) then return end
  local ai_win = vim.fn.win_findbuf(last_ai_buf)[1]
  if not ai_win then return end

  vim.api.nvim_set_current_win(ai_win)
  local job_id = vim.b[last_ai_buf].terminal_job_id
  if job_id then vim.fn.chansend(job_id, location) end
  vim.cmd 'startinsert'
end

local function quit_window_or_buffer()
  if vim.bo.buftype ~= 'terminal' then
    vim.cmd 'confirm q'
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local wins = vim.fn.win_findbuf(bufnr) or {}

  if #wins > 1 then
    vim.api.nvim_win_close(0, false)
  else
    vim.cmd 'bd!'
  end
end

M.set_mappings {
  n = {
    -- Leader and movement tweaks
    ['<Space>'] = { '<Nop>', silent = true },
    ['k'] = { "v:count == 0 ? 'gk' : 'k'", expr = true, silent = true, desc = 'Visual line up' },
    ['j'] = { "v:count == 0 ? 'gj' : 'j'", expr = true, silent = true, desc = 'Visual line down' },
    ["'"] = { quit_window_or_buffer, desc = 'Quit' },
    ['<C-g>'] = {
      function()
        local filePath = vim.fn.expand '%:p'
        if filePath == '' then
          print 'No file loaded'
        else
          print(filePath)
          vim.fn.setreg('+', filePath)
        end
      end,
      desc = 'Show Full Path',
    },
    ['<leader>r'] = { copy_location_to_ai, desc = 'Reference in AI' },
    ['gz'] = { '<cmd>:e <cfile><CR>', desc = 'open file under cursor in nvim' },
    ['<leader>w'] = { '<cmd>w<cr>', desc = 'Save' },
    ['<leader>n'] = { '<cmd>enew<cr>', desc = 'New File' },
    ["<leader>'"] = { '<cmd>:edit!<cr>', desc = 'Reload buffer' },

    ['<leader>pp'] = {
      function() require('lazy').home() end,
      desc = 'Plugins',
    },
    [']f'] = { function() nav_changed_file 'next' end, desc = 'Next changed file' },
    ['[f'] = { function() nav_changed_file 'prev' end, desc = 'Prev changed file' },
    ['H'] = { '<cmd>:bprevious<cr>', desc = 'Prev Buffer' },
    ['L'] = { '<cmd>:bnext<cr>', desc = 'Next Buffer' },
    ['<leader>C'] = { delete_all_unused_bufs, desc = 'Close all buffers except for tree & terminals current' },
    ['<C-1>'] = { function() goto_tab(1) end, desc = 'Tab 1' },
    ['<C-2>'] = { function() goto_tab(2) end, desc = 'Tab 2' },
    ['<C-3>'] = { function() goto_tab(3) end, desc = 'Tab 3' },
    ['<C-t>'] = {
      function()
        vim.api.nvim_command 'terminal'
        vim.cmd 'startinsert'
      end,
    },
    ['<leader>t'] = {
      function() open_ai_terminal(false) end,
      desc = 'AI (full on alpha, vsplit otherwise)',
    },
    ['<C-s>'] = {
      function() open_ai_terminal(true) end,
      desc = 'AI resume (full on alpha, vsplit otherwise)',
    },
    ['t'] = {
      function()
        vim.api.nvim_command '25split | terminal'
        vim.cmd 'startinsert'
      end,
    },
    ['T'] = {
      function()
        vim.api.nvim_command 'vsplit | terminal'
        vim.cmd 'startinsert'
      end,
    },
    ['\\'] = { '<C-w>v', desc = 'Vertical Split' },
    ['-'] = { '<C-w>s', desc = 'Horizontal Split' },
  },
  t = {
    ['<C-BS>'] = { '<C-w>', desc = 'Delete word' },
    ['<esc>'] = { '<C-\\><C-n>', desc = 'Normal mode' },
    ['<C-j>'] = { '<cmd>wincmd j<cr>', desc = 'Terminal down window navigation' },
    ['<C-k>'] = { '<cmd>wincmd k<cr>', desc = 'Terminal up window navigation' },
    ['<C-h>'] = { '<cmd>wincmd h<cr>', desc = 'Terminal left window navigation' },
    ['<C-l>'] = { '<cmd>wincmd l<cr>', desc = 'Terminal right window navigation' },
    ['<C-1>'] = { function() goto_tab(1) end, desc = 'Tab 1' },
    ['<C-2>'] = { function() goto_tab(2) end, desc = 'Tab 2' },
    ['<C-3>'] = { function() goto_tab(3) end, desc = 'Tab 3' },
  },
  i = {
    ['<C-h>'] = { '<left>', desc = 'Move left' },
    ['<C-l>'] = { '<right>', desc = 'Move right' },
    ['<C-j>'] = { '<down>', desc = 'Move down' },
    ['<C-k>'] = { '<up>', desc = 'Move up' },
    ['<C-1>'] = { function() goto_tab(1) end, desc = 'Tab 1' },
    ['<C-2>'] = { function() goto_tab(2) end, desc = 'Tab 2' },
    ['<C-3>'] = { function() goto_tab(3) end, desc = 'Tab 3' },
  },
  v = {
    ['<Space>'] = { '<Nop>', silent = true },
    ['<S-Tab>'] = { '<gv', desc = 'Unindent line' },
    ['<Tab>'] = { '>gv', desc = 'Indent line' },
  },
}
