-- utility functions for surrounding text with pairs
return {
  "kylechui/nvim-surround",
  -- version = "main",   -- Use for stability; omit to use `main` branch for the latest features
  lazy = true,
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup()
  end,
}
