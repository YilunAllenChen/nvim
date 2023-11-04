local function alpha_render(_, opts)
  require("alpha").setup(opts.config)

  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    desc = "Add Alpha dashboard footer",
    once = true,
    callback = function()
      local stats = require("lazy").stats()
      local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
      opts.section.footer.val =
        { " ", " ", " ", "AstroNvim loaded " .. stats.count .. " plugins  in " .. ms .. "ms" }
      opts.section.footer.opts.hl = "DashboardFooter"
      pcall(vim.cmd.AlphaRedraw)
    end,
  })
end

return {
  "goolord/alpha-nvim",
  cmd = "Alpha",
  lazy = false,
  opts = function()
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
    dashboard.config.layout[1].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }
    dashboard.config.layout[3].val = 5
    dashboard.config.opts.noautocmd = true
    return dashboard
  end,
  config = alpha_render,
}


