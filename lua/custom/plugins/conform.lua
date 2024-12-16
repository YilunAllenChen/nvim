return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        cpp = { 'clang-format' },
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        python = { 'autoflake', 'isort', 'black' },
        -- Use a sub-list to run only the first available formatter
        javascript = { 'prettierd', 'prettier' },
        json = { 'prettier' },
      },
      format_after_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = 'never',
      },
    }
  end,
}
