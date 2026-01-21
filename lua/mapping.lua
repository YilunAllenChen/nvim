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
  if tab then vim.api.nvim_set_current_tabpage(tab) end
end

local function toggle_inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = bufnr } or {}

  if vim.tbl_isempty(clients) then
    vim.notify('No LSP client attached', vim.log.levels.ERROR)
    return
  end

  local supports = false
  for _, client in ipairs(clients) do
    if client.server_capabilities.inlayHintProvider then
      supports = true
      break
    end
  end

  if not supports then
    vim.notify('Attached LSP clients do not support inlay hints', vim.log.levels.WARN)
    return
  end

  local opts = { bufnr = bufnr }
  local enabled = false
  local ok, result = pcall(vim.lsp.inlay_hint.is_enabled, opts)
  if ok then
    enabled = result
  else
    ok, result = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
    if ok then enabled = result end
  end

  local ok_enable = pcall(vim.lsp.inlay_hint.enable, not enabled, opts)
  if not ok_enable then pcall(vim.lsp.inlay_hint.enable, not enabled, bufnr) end
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

    ["'"] = {
      quit_window_or_buffer,
      desc = 'Quit',
    },
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
    [';'] = { '<cmd>:HopWord<cr>', desc = 'Hop' },
    ['gz'] = { '<cmd>:e <cfile><CR>', desc = 'open file under cursor' },
    ['<leader>w'] = { '<cmd>w<cr>', desc = 'Save' },
    ['<leader>n'] = { '<cmd>enew<cr>', desc = 'New File' },
    ["<leader>'"] = { '<cmd>:edit!<cr>', desc = 'Reload buffer' },

    ['<leader>pp'] = {
      function() require('lazy').home() end,
      desc = 'Plugins',
    },
    ['K'] = { function() vim.lsp.buf.hover { border = 'rounded' } end, desc = 'Hover symbol details' },
    ['<leader>lf'] = { function() vim.lsp.buf.format() end, desc = 'Format buffer' },
    ['gI'] = { function() vim.lsp.buf.implementation() end, desc = 'implementation' },
    ['<leader>lr'] = {
      function()
        vim.lsp.buf.rename()
        vim.cmd 'silent! wa'
      end,
      desc = 'Rename current symbol',
    },
    ['<leader>lx'] = { '<cmd>:LspRestart<cr>', desc = 'LSP Restart' },
    ['<leader>la'] = { function() require('actions-preview').code_actions() end, desc = 'Code action' },
    ['<leader>lI'] = { '<cmd>LspInfo<cr>', desc = 'LSP information' },
    ['<leader>ld'] = { function() vim.diagnostic.open_float { border = 'rounded' } end, desc = 'Hover diagnostics' },
    ['<leader>li'] = { toggle_inlay_hints, desc = 'Toggle inlay hints' },
    ['[d'] = { function() vim.diagnostic.jump { count = -1, float = false } end, desc = 'Previous diagnostic' },
    [']d'] = { function() vim.diagnostic.jump { count = 1, float = false } end, desc = 'Next diagnostic' },
    ['H'] = { '<cmd>:bprevious<cr>', desc = 'Prev Buffer' },
    ['L'] = { '<cmd>:bnext<cr>', desc = 'Next Buffer' },
    ['<leader>C'] = { delete_all_unused_bufs, desc = 'Close all buffers except for tree & terminals current' },
    ['<leader>c'] = { ':bnext<CR>:bd#<CR>', desc = 'Close buffer' },
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
      function()
        if vim.bo.filetype == 'alpha' then
          -- From the alpha dashboard, use full screen
          vim.api.nvim_command 'terminal cursor-agent'
        else
          -- Otherwise, keep the vertical split behavior
          vim.api.nvim_command 'vsplit | terminal cursor-agent'
        end
        vim.api.nvim_command 'startinsert'
      end,
      desc = 'AI (full on alpha, vsplit otherwise)',
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
    ['<esc>'] = { '<C-\\><C-n>' },
    ['<C-BS>'] = { '<C-w>', desc = 'Delete word' },
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
