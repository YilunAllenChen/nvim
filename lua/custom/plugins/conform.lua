return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        cpp = { 'clang-format' },
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        python = { 'ruff_format', 'ruff_organize_imports' },
        -- Use a sub-list to run only the first available formatter
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
        jsonnet = { 'jsonnetfmt' },
        ocaml = { 'ocamlformat' },
      },
      formatters = {
        prettier = { command = 'prettier', args = { '$FILENAME', '--tab-width', '4' } },
      },
      format_after_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = 'never',
      },
    }
  end,
}
