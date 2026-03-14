local terminal_follow_group = vim.api.nvim_create_augroup('TerminalFollowOutput', { clear = true })

vim.api.nvim_create_autocmd({ 'TermOpen', 'BufWinEnter' }, {
  group = terminal_follow_group,
  pattern = 'term://*',
  callback = function(args)
    local winid = vim.fn.bufwinid(args.buf)
    if winid == -1 then return end

    local last_line = vim.api.nvim_buf_line_count(args.buf)
    pcall(vim.api.nvim_win_set_cursor, winid, { last_line, 0 })
  end,
})
