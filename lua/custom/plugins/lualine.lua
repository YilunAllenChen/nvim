-- tabline and statusline
local function custom()
  local recording = vim.fn.reg_recording()
  local status = ''
  if recording ~= '' then
    status = status .. [[Recording macro @ ]] .. recording .. ';'
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
      component_separators = '|',
      globalstatus = true,
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = { custom },
      lualine_x = { 'filetype' },
      lualine_y = { "require'lsp-status'.status()" },
      lualine_z = { 'location' },
    },
    tabline = {
      lualine_z = {
        { 'filename', file_status = true, path = 2 },
      },
      lualine_b = {
        'buffers',
      },
    },
  },
}
