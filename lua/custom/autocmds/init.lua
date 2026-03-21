local terminal_follow_group = vim.api.nvim_create_augroup('TerminalFollowOutput', { clear = true })

local function scroll_terminal_windows_to_bottom(bufnr, opts)
  opts = opts or {}
  local last_line = vim.api.nvim_buf_line_count(bufnr)
  local current_win = vim.api.nvim_get_current_win()

  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(winid) and vim.api.nvim_win_get_buf(winid) == bufnr then
      if opts.skip_current and winid == current_win then goto continue end
      pcall(vim.api.nvim_win_set_cursor, winid, { last_line, 0 })
    end
    ::continue::
  end
end

local function attach_terminal_follow(bufnr)
  if vim.b[bufnr].terminal_follow_attached then return end
  vim.b[bufnr].terminal_follow_attached = true

  vim.api.nvim_buf_attach(bufnr, false, {
    on_lines = function()
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          scroll_terminal_windows_to_bottom(bufnr, { skip_current = true })
        end
      end)
    end,
  })
end

vim.api.nvim_create_autocmd({ 'TermOpen', 'BufWinEnter' }, {
  group = terminal_follow_group,
  pattern = 'term://*',
  callback = function(args)
    attach_terminal_follow(args.buf)
    scroll_terminal_windows_to_bottom(args.buf)
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
  pattern = 'term://*',
  callback = function()
    vim.cmd('startinsert')
  end,
})
