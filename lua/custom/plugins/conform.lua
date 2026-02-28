return {
  'stevearc/conform.nvim',
  opts = {},
  event = 'BufWritePre',
  config = function()
    local autoformat = true
    vim.api.nvim_create_user_command('ConformDisableAutoformat', function()
      autoformat = false
      vim.notify('Conform: autoformat disabled for this session', vim.log.levels.INFO)
    end, {})

    require('conform').setup {
      formatters_by_ft = {
        cpp = { 'clang-format' },
        h = { 'clang-format' },
        lua = { 'stylua' },
        python = { 'ruff_format', 'ruff_organize_imports', 'ruff_fix' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
        jsonnet = { 'jsonnetfmt' },
        ocaml = { 'ocamlformat' },
      },
      formatters = {},
      format_after_save = function()
        if not autoformat then return end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
    }
  end,
}
