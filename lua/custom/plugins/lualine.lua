-- tabline and statusline
local function macro_indicator()
  local recording = vim.fn.reg_recording()
  local status = ''
  if recording ~= '' then status = status .. [[Recording macro @ ]] .. recording .. '' end
  return status
end
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  opts = {
    options = {
      icons_enabled = true,
      component_separators = '',
      section_separators = { left = '', right = '' },
      refresh = { statusline = 500 },
    },
    sections = {
      lualine_a = { 'branch', macro_indicator },
      lualine_b = { { 'filename', file_status = true, path = 2 }, 'filesize' },
      lualine_c = {},
      lualine_x = {
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
    extensions = { 'mason', 'lazy' },
  },
}
