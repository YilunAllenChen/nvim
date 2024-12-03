-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.cmd 'set foldexpr&'
  end,
})

-- Autocommand for terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    local function get_last_part_of_path(path)
      return path:match '^.*/(.*)$'
    end
    -- Helper function to read the `.conda-env` file
    local function get_conda_env()
      local registry = {
        ['alsenal'] = 'alsenal',
        ['data'] = 'data',
        ['data-utils'] = 'du',
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
  end,
})
