return {
  'gbprod/yanky.nvim',
  opts = {
    ring = { history_length = 20 },
    picker = { telescope = { use_default_mappings = false } },
    system_clipboard = {
      sync_with_ring = true,
      clipboard_register = nil,
    },
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 500,
    },
    preserve_cursor_position = {
      enabled = true,
    },
    textobj = {
      enabled = false,
    },
  },
}
