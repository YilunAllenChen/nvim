vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local ok, snacks = pcall(require, 'snacks.project')
    if not ok then return end

    local root = snacks.get_root(vim.api.nvim_buf_get_name(0))
    if root and vim.fn.getcwd() ~= root then vim.cmd.tcd(root) end
  end,
})
