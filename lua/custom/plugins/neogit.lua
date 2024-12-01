return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
	},
	config = {
		git_services = {
			["git.drwholdings.com"] =
			"https://git.drwholdings.com/${owner}/${repository}/compare/${branch_name}?expand=1",
		},
	}
}
