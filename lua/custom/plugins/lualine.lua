return
{
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-lua/lsp-status.nvim',
  },
  opts = {
    options = {
      icons_enabled = false,
      theme = 'tokyonight',
      component_separators = '|',
      globalstatus = true,
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = { 'filename' },
      lualine_x = { 'filetype' },
      lualine_y = { "require'lsp-status'.status()" },
      lualine_z = { 'location' },
    },
    tabline = {
      lualine_a = { 'buffers' },
    },
  },
}
