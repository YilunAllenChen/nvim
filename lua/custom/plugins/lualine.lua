-- tabline and statusline
local function macro_indicator()
  local recording = vim.fn.reg_recording()
  local status = ''
  if recording ~= '' then
    status = status .. [[Recording macro @ ]] .. recording .. ''
  end
  return status
end
return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-lua/lsp-status.nvim',
  },
  opts = {
    options = {
      icons_enabled = true,
      theme = 'tokyonight',
      component_separators = '',
      globalstatus = true,
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', macro_indicator },
      lualine_c = { { 'filename', file_status = true, path = 2 }, 'filesize' },
      lualine_x = {
        "require('lsp-status').status()",
        {
          'diff',
          symbols = { added = ' ', modified = ' ', removed = ' ' },
          diff_color = {
            added = { fg = '#88ff88' },
            modified = { fg = '#77ffff' },
            removed = { fg = '#ff8888' },
          },
        },
        {
          'diagnostics',
          sources = { 'nvim_diagnostic' },
          symbols = { error = ' ', warn = ' ', info = ' ' },
          diagnostics_color = {
            color_error = { fg = '#ff5555' },
            color_warn = { fg = 'yellow' },
            color_info = { fg = 'cyan' },
          },
        },
        'location',
        'filetype',
      },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {
      lualine_a = { { 'buffers', symbols = { modified = ' ', alternate_file = '' } } },
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'os.date()' },
    },
    extensions = { 'nvim-tree', 'mason' },
  },
}
