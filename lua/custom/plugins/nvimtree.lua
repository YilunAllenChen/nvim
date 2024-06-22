-- file tree

local function nvim_tree_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
  vim.keymap.set('n', 'l', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts 'Close')
  vim.keymap.set('n', '<CR>', api.node.open.tab_drop, opts 'Tab drop')
end

return {
  'nvim-tree/nvim-tree.lua',
  as = 'nvim-tree',
  event = 'VeryLazy',
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require('nvim-tree').setup {
      sort_by = 'case_sensitive',
      view = {
        width = 30,
        adaptive_size = true,
      },
      filters = {
        dotfiles = true,
      },
      on_attach = nvim_tree_attach,
      live_filter = {
        prefix = '[FILTER]: ',
        always_show_folders = false, -- Turn into false from true by default
      },
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
    }
  end,
}
