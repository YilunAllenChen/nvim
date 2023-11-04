return {
  "smoka7/hop.nvim",
  lazy = true,
  event = "VeryLazy",
  config = function()
    require("hop").setup {
      multi_windows = true,
    }
  end,
}
