local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
[[]],
[[]],
[[   ___   _  _               _             _   _                      _            ]],
[[  / _ \ | || |             ( )           | \ | |                    (_)           ]],
[[ / /_\ \| || |  ___  _ __  |/  ___       |  \| |  ___   ___  __   __ _  _ __ ___  ]],
[[ |  _  || || | / _ \| '_ \    / __|      | . ` | / _ \ / _ \ \ \ / /| || '_ ` _ \ ]],
[[ | | | || || ||  __/| | | |   \__ \      | |\  ||  __/| (_) | \ V / | || | | | |  ]],
[[ \_| |_/|_||_| \___||_| |_|   |___/      \_| \_/ \___| \___/   \_/  |_||_| |_| |_ ]],
[[]],
[[]],
}
dashboard.section.buttons.val = {
	dashboard.button("p", "  Find file", ":Telescope find_files hidden=true<CR>"),
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("r", "  Find Repo", ":Telescope projects <CR>"),
	dashboard.button("R", "  Recently used files", ":Telescope oldfiles <CR>"),
	dashboard.button("f", "  Find text", ":Telescope live_grep <CR>"),
	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
	dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

local function footer()
-- NOTE: requires the fortune-mod package to work
	-- local handle = io.popen("fortune")
	-- local fortune = handle:read("*a")
	-- handle:close()
	-- return fortune
	return "Allen Chen"
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)
