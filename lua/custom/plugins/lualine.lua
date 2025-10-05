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
      lualine_b = { { 'filename', file_status = true, path = 2 } },
      lualine_c = {},
      lualine_x = {
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
    extensions = {},
  },
}
