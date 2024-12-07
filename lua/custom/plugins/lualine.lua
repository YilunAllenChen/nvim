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
      component_separators = '|',
      globalstatus = true,
      section_separators = { left = '', right = '' },
      refresh = {
        statusline = 300,
        tabline = 500,
        winbar = 300,
      },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { macro_indicator },
      lualine_c = { { 'filename', file_status = true, path = 2 } },
      lualine_x = { "require'lsp-status'.status()" },
      lualine_y = { 'branch' },
      lualine_z = { 'filetype', 'location', 'filesize' },
    },
    tabline = {
      lualine_b = { 'buffers' },
      lualine_z = { 'os.date()' },
    },
    extensions = { 'nvim-tree', 'mason' },
  },
}
