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

M.set_mappings {
  n = {
    -- Leader and movement tweaks
    ['<Space>'] = { '<Nop>', silent = true },
    ['k'] = { "v:count == 0 ? 'gk' : 'k'", expr = true, silent = true, desc = 'Visual line up' },
    ['j'] = { "v:count == 0 ? 'gj' : 'j'", expr = true, silent = true, desc = 'Visual line down' },

    -- Blazingly Fast Shortcuts
    ["'"] = { '<cmd>:confirm quit<cr>', desc = 'close' },
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
    ['<leader>li'] = {
      function()
        local clients = vim.lsp.get_clients()
        if clients == nil or clients[1] == nil then return end
        local client = clients[1]
        if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {}) end
      end,
      desc = 'Enable inlay hints',
    },
    ['[d'] = { function() vim.diagnostic.jump { count = -1, float = false } end, desc = 'Previous diagnostic' },
    [']d'] = { function() vim.diagnostic.jump { count = 1, float = false } end, desc = 'Next diagnostic' },
    -- Buffers
    ['H'] = { '<cmd>:bprevious<cr>', desc = 'Prev Buffer' },
    ['L'] = { '<cmd>:bnext<cr>', desc = 'Next Buffer' },
    ['<leader>C'] = { delete_all_unused_bufs, desc = 'Close all buffers except for tree & terminals current' },

    ['<leader>c'] = { ':bnext<CR>:bd#<CR>', desc = 'Close buffer' },
    ['<leader>f'] = { 'Find' },
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
          vim.api.nvim_command 'terminal codex'
        else
          -- Otherwise, keep the vertical split behavior
          vim.api.nvim_command 'vsplit | terminal codex'
        end
        vim.api.nvim_command 'startinsert'
      end,
      desc = 'Open codex (full on alpha, vsplit otherwise)',
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
    ['<leader><leader>c'] = { '<cmd>e ~/.config/fish/config.fish<cr>', desc = 'Edit fish config' },
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
    ['<C-h>'] = { '<left>', desc = 'Move left' },
    ['<C-l>'] = { '<right>', desc = 'Move right' },
    ['<C-j>'] = { '<down>', desc = 'Move down' },
    ['<C-k>'] = { '<up>', desc = 'Move up' },
  },
  v = {
    ['<Space>'] = { '<Nop>', silent = true },
    ['<S-Tab>'] = { '<gv', desc = 'Unindent line' },
    ['<Tab>'] = { '>gv', desc = 'Indent line' },
  },
}
