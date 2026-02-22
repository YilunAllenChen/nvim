return {
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    build = vim.g.lazyvim_blink_main and 'cargo build --release',
    dependencies = {
      {
        'saghen/blink.compat',
        version = '*',
        lazy = true,
        opts = {},
      },
      'moyiz/blink-emoji.nvim',
      'hrsh7th/cmp-calc',
    },
    version = '*',

    cmdline = { enabled = true },
    opts = {
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
        sorts = {
          'exact',
          'score',
          'sort_text',
        },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        list = {
          selection = { preselect = false, auto_insert = true },
        },
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
        trigger = {
          show_on_backspace = true,
        },
      },
      signature = { enabled = true, window = { border = 'rounded' } },
      keymap = {
        preset = 'none',
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-space>'] = { 'show' },
        ['<tab>'] = { 'accept', 'fallback' },
        ['<S-tab>'] = { 'select_prev' },
        ['C-u'] = { 'scroll_documentation_up', 'fallback' },
        ['C-d'] = { 'scroll_documentation_down', 'fallback' },
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
            score_offset = -10,
          },
          calc = {
            module = 'blink.compat.source',
            name = 'calc',
          },
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
          lsp = {
            max_items = 50,
            score_offset = 100,
          },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },
}
