-- Github copilot
return {
  -- should disable if there are compliance issues
  "zbirenbaum/copilot.lua",
  lazy = true,
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<Right>",
        },
      },
    }
  end,
}
