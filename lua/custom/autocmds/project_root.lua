-- Auto-change to project root for Python files
-- Deals with cases where jumping to definition changes cwd to file dir

-- Helper function to find project root
local function find_project_root(start_path)
  local project_indicators = {
    '.git',
    'pyproject.toml',
    'setup.py',
    'requirements.txt',
    'Pipfile',
    'poetry.lock',
    'Cargo.toml',
    'package.json',
  }

  for _, indicator in ipairs(project_indicators) do
    local found = vim.fn.finddir(indicator, start_path .. ';')
    if found ~= '' then return vim.fn.fnamemodify(found, ':h') end
  end

  return nil
end

local project_root_group = vim.api.nvim_create_augroup('ProjectRoot', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == '' then return end

    -- Skip if this is a help file, terminal, or other special buffer
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = 0 })
    if buftype ~= '' then return end

    -- Get the current working directory
    local cwd = vim.fn.getcwd()

    -- Start from the file's directory and work up
    local file_dir = vim.fn.fnamemodify(bufname, ':h')
    if file_dir == '.' then return end

    local project_root = find_project_root(file_dir)

    -- If we found a project root and we're not already there, change to it
    if project_root and project_root ~= cwd then vim.cmd('cd ' .. vim.fn.fnameescape(project_root)) end
  end,
  group = project_root_group,
  pattern = '*.py', -- Only trigger for Python files
})
