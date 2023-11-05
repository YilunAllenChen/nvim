-- although deprecated, null-ls is still best of its kind.
-- provides executors for code formatting, code actions, etc.
-- Note that after installing in mason, probably still need to add the executor here.
return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, config)
      local null_ls = require("null-ls")
      config.sources = {
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.formatting.black
      }
      return config
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = { "prettier", "stylua", "black", "jq" },
    },
  },
}
