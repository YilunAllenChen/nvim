local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

return {
  {
    'saghen/blink.compat',
    version = '*',
    lazy = true,
    opts = {},
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      'moyiz/blink-emoji.nvim',
      'hrsh7th/cmp-calc',
    },
    version = '*',
    opts = {
      completion = {
        menu = {
          border = 'rounded',
        },
        documentation = {
          window = {
            border = 'rounded',
          },
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        list = { selection = 'auto_insert' },
      },

      signature = { enabled = true },
      keymap = {
        -- set to 'none' to disable the 'default' preset
        preset = 'default',

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-e>'] = {},
        ['<C-space>'] = {
          function(cmp)
            cmp.show { providers = { 'snippets' } }
          end,
        },
        ['<tab>'] = {
          function(cmp)
            if has_words_before() then
              return cmp.select_next()
            else
              return cmp.select_and_accept()
            end
          end,
          'fallback',
        },
        ['<S-tab>'] = {
          function(cmp)
            cmp.select_prev()
          end,
        },
        ['C-u'] = { 'scroll_documentation_up', 'fallback' },
        ['C-d'] = { 'scroll_documentation_down', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'emoji', 'calc', 'dadbod' },
        providers = {
          emoji = {
            module = 'blink-emoji',
            name = 'Emoji',
            score_offset = 15, -- Tune by preference
          },
          calc = {
            module = 'blink.compat.source',
            name = 'calc',
          },
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },
}
