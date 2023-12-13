-- Autocomplete
return {
  'hrsh7th/nvim-cmp',
  lazy = true,
  event = 'BufReadPre',
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp', dependencies = 'nvim-cmp' },
    { 'hrsh7th/cmp-path',     dependencies = 'nvim-cmp' },
    { 'hrsh7th/cmp-buffer',   dependencies = 'nvim-cmp' },
    { 'hrsh7th/cmp-cmdline',  dependencies = 'nvim-cmp' },
    { 'hrsh7th/cmp-emoji',    dependencies = 'nvim-cmp' },
    { 'hrsh7th/cmp-calc',     dependencies = 'nvim-cmp' },
    'rafamadriz/friendly-snippets',
    'onsails/lspkind.nvim',
  },
  config = function()
    local cmp = require 'cmp'

    local border_opts = {
      border = 'rounded',
      winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
    }
    local function has_words_before()
      local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
    end
    local opts = {
      snippet = {
      },
      mapping = {
        ['<Up>'] = cmp.mapping.select_prev_item(),
        ['<Down>'] = cmp.mapping.select_next_item(),
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping {
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        },
        ['<C-Space>'] = cmp.mapping.complete(),
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm { select = false },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, {
          'i',
          's',
        }),
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          local kind = require('lspkind').cmp_format { mode = 'symbol_text', maxwidth = 50 } (entry, vim_item)
          local strings = vim.split(kind.kind, '%s', { trimempty = true })
          local source_map = {
            nvim_lsp = 'LSP',
            buffer = 'Buffer',
            path = 'Path',
            emoji = 'Emoji',
            calc = 'Calc',
          }
          kind.kind = (strings[1] or '') .. ' '
          kind.menu = '    (' .. source_map[entry.source.name] .. '.' .. (strings[2] or '') .. ')'
          return kind
        end,
        expandable_indicator = false,
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'emoji' },
        { name = 'calc' },
      },
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      entries = { name = 'custom', selection_order = 'near_cursor' },
      window = {
        completion = cmp.config.window.bordered(border_opts),
        documentation = cmp.config.window.bordered(border_opts),
      },
      experimental = {
        ghost_text = false,
        native_menu = false,
      },
    }
    cmp.setup(opts)
  end,
}
