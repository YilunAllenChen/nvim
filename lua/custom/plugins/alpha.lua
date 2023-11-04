local function alpha_render()
  local dashboard = require "alpha.themes.dashboard"
  dashboard.section.header.val = {
    "▄▀█ █░░ █░░ █▀▀ █▄░█ ▀ █▀   █▄░█ █▀▀ █▀█ █░█ █ █▀▄▀█",
    "█▀█ █▄▄ █▄▄ ██▄ █░▀█ ░ ▄█   █░▀█ ██▄ █▄█ ▀▄▀ █ █░▀░█",
    "",
    "              \\",
    "               \\",
    "                          '-.",
    "                .---._      .--'",
    "              /       `-..__)  ,-'",
    "             |    0           /",
    "              --.__,   .__.,`",
    "               `-.___'._\\_.'",
  }
  dashboard.section.header.opts.hl = "DashboardHeader"
  dashboard.section.buttons.val = {}
  dashboard.config.layout[1].val = vim.fn.max { 10, vim.fn.floor(vim.fn.winheight(0) * 0.2) }
  dashboard.config.layout[3].val = 5
  dashboard.config.opts.noautocmd = true
  require("alpha").setup(dashboard.config)

  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    desc = "Add Alpha dashboard footer",
    once = true,
    callback = function()
      local stats = require("lazy").stats()
      local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
      dashboard.section.footer.val =
      { " ", " ", " ", "Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms" }
      dashboard.section.footer.opts.hl = "DashboardFooter"
      pcall(vim.cmd.AlphaRedraw)
    end,
  })
end

return {
  "goolord/alpha-nvim",
  cmd = "Alpha",
  lazy = false,
  config = alpha_render,
}
