local function toggle_inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = bufnr } or {}
  if vim.tbl_isempty(clients) then
    vim.notify('No LSP client attached', vim.log.levels.ERROR)
    return
  end
  local supports = false
  for _, client in ipairs(clients) do
    if client.server_capabilities.inlayHintProvider then
      supports = true
      break
    end
  end
  if not supports then
    vim.notify('Attached LSP clients do not support inlay hints', vim.log.levels.WARN)
    return
  end
  local opts = { bufnr = bufnr }
  local enabled = false
  local ok, result = pcall(vim.lsp.inlay_hint.is_enabled, opts)
  if ok then
    enabled = result
  else
    ok, result = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
    if ok then enabled = result end
  end
  local ok_enable = pcall(vim.lsp.inlay_hint.enable, not enabled, opts)
  if not ok_enable then pcall(vim.lsp.inlay_hint.enable, not enabled, bufnr) end
end

local lsp_keys = {
  { 'K', function() vim.lsp.buf.hover { border = 'rounded' } end, desc = 'Hover symbol details' },
  { 'gI', function() vim.lsp.buf.implementation() end, desc = 'Implementation' },
  {
    '<leader>lr',
    function()
      vim.lsp.buf.rename()
      vim.cmd 'silent! wa'
    end,
    desc = 'Rename current symbol',
  },
  { '<leader>lf', function() require('conform').format { async = true, lsp_format = 'fallback' } end, desc = 'Format current buffer' },
  {
    '<leader>lx',
    function()
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_clients { bufnr = bufnr }
      for _, client in ipairs(clients) do
        client:stop()
      end
      vim.defer_fn(function() vim.cmd 'edit' end, 200)
    end,
    desc = 'LSP Restart',
  },
  { '<leader>lI', '<cmd>checkhealth vim.lsp<cr>', desc = 'LSP information' },
  { '<leader>ld', function() vim.diagnostic.open_float { border = 'rounded' } end, desc = 'Hover diagnostics' },
  { '<leader>li', toggle_inlay_hints, desc = 'Toggle inlay hints' },
  { '[d', function() vim.diagnostic.jump { count = -1, float = false } end, desc = 'Previous diagnostic' },
  { ']d', function() vim.diagnostic.jump { count = 1, float = false } end, desc = 'Next diagnostic' },
}

local mason_servers = {
  ty = {
    settings = {
      ty = {
        diagnosticMode = 'workspace',
      },
    },
  },
  ruff = {
    on_attach = function(client) client.server_capabilities.hoverProvider = false end,
  },
  clangd = {
    cmd = {
      'clangd',
      '--query-driver=/usr/bin/g++*',
      '--background-index',
      '--clang-tidy',
      '--header-insertion=iwyu',
    },
  },
}

-- servers not in mason yet
local raw_servers = {}

local function setup_mason() require('mason').setup() end

local function setup_mason_lspconfig()
  for server_name, server in pairs(raw_servers) do
    vim.lsp.enable(server_name)
  end

  local capabilities = require('blink.cmp').get_lsp_capabilities()
  for server_name, server in pairs(mason_servers) do
    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
    vim.lsp.config(server_name, server)
  end

  require('mason-lspconfig').setup {
    ensure_installed = vim.tbl_keys(mason_servers),
    automatic_installation = true,
  }
end

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } },
  },
  {
    'mason-org/mason.nvim',
    cmd = 'Mason',
    keys = {
      { '<leader>pm', '<cmd>Mason<cr>', desc = 'Mason Installer' },
    },
    config = setup_mason,
  },
  {
    'mason-org/mason-lspconfig.nvim',
    event = 'BufReadPre',
    keys = lsp_keys,
    dependencies = {
      'mason-org/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    config = setup_mason_lspconfig,
  },
  { 'jubnzv/virtual-types.nvim', event = { 'BufReadPre', 'BufNewFile' } },
}
