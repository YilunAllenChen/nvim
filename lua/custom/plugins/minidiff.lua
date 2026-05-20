return {
  'echasnovski/mini.diff',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    view = {
      style = 'sign',
      signs = { add = '+', change = '~', delete = '-' },
    },
    mappings = {
      apply = 'gh',
      reset = 'gH',
      textobject = 'gh',
      goto_first = '[H',
      goto_prev = '[h',
      goto_next = ']h',
      goto_last = ']H',
    },
  },
  keys = {
    {
      '<leader>d',
      function()
        local helper = require('custom.git_branch_diff')
        local md = require('mini.diff')
        local r = helper.resolve()
        if r.action == 'dirty' then
          md.toggle_overlay()
          return
        end
        if r.action == 'on_default' then
          vim.notify("You're already on " .. r.branch .. ', no change', vim.log.levels.INFO)
          return
        end
        local buf = vim.api.nvim_get_current_buf()
        local file = vim.api.nvim_buf_get_name(buf)
        local root = helper.git_root()
        if not root or file == '' then
          md.toggle_overlay()
          return
        end
        local rel = file:sub(1, #root + 1) == root .. '/' and file:sub(#root + 2) or file
        local ref = vim.fn.systemlist { 'git', '-C', root, 'show', r.branch .. ':' .. rel }
        if vim.v.shell_error ~= 0 then
          vim.notify('File not in ' .. r.branch, vim.log.levels.WARN)
          return
        end
        md.set_ref_text(buf, ref)
        md.toggle_overlay(buf)
      end,
      desc = 'Toggle inline diff overlay (vs master if clean)',
    },
    { '<leader>hs', 'ghgh', remap = true, desc = 'Stage hunk' },
    { '<leader>hr', 'gHgH', remap = true, desc = 'Reset hunk' },
  },
}
