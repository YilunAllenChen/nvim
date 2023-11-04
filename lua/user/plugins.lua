local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clonavarasune",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here

	use({ "wbthomason/packer.nvim"}) -- Have packer manage itself
	use({ "nvim-lua/plenary.nvim"}) -- Useful lua functions used by lots of plugins
	use({ "windwp/nvim-autopairs"}) -- Autopairs, integrates with both cmp and treesitter
	use({ "numToStr/Comment.nvim" })
	use({ "JoosepAlviste/nvim-ts-context-commentstring" })
	use({ "kyazdani42/nvim-web-devicons" })
	use({ "kyazdani42/nvim-tree.lua" })
	use({ "moll/vim-bbye" })
	use({ "nvim-lualine/lualine.nvim" })
	use({ "akinsho/toggleterm.nvim" })
	use({ "ahmedkhalf/project.nvim" })
	use({ "lewis6991/impatient.nvim" })
	use({ "lukas-reineke/indent-blankline.nvim" })
	use({ "goolord/alpha-nvim" })
	use("folke/which-key.nvim")

	-- Colorschemes
	use({ "folke/tokyonight.nvim" })
	use("lunarvim/darkplus.nvim")
	use {"AlphaTechnolog/onedarker.nvim"}
  use 'navarasu/onedark.nvim'
  use 'tiagovla/tokyodark.nvim'

	-- cmp plugins
	use({ "hrsh7th/nvim-cmp" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer" }) -- buffer completions
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-nvim-lua" })

	-- snippets
  -- these are overlapping with the lsp configs, so turning them off for now
	--[[ use({ "L3MON4D3/LuaSnip" }) --snippet engine ]]
	--[[ use({ "rafamadriz/friendly-snippets" }) -- a bunch of snippets to use ]]

	-- LSP
	use({ "neovim/nvim-lspconfig" }) -- enable LSP
	use({ "williamboman/nvim-lsp-installer" }) -- simple to use language server installer
	use({ "jose-elias-alvarez/null-ls.nvim" }) -- for formatters and linters
  use { "ray-x/lsp_signature.nvim" }

  -- comments
  use {'kkoomen/vim-doge', run = ':call doge#install()' }

	-- Telescope
	use {
	  "nvim-telescope/telescope.nvim",
	  requires = {
	    { "nvim-telescope/telescope-live-grep-args.nvim" },
	  },
	  config = function()
	    require("telescope").load_extension("live_grep_args")
	  end
	}

	-- Treesitter
  use({
		"nvim-treesitter/nvim-treesitter",
	})

	-- Git
	use({ "lewis6991/gitsigns.nvim" })
  use({ "ruifm/gitlinker.nvim", requires = 'nvim-lua/plenary.nvim',})

	-- fzf
	use {'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
	use {'junegunn/fzf.vim'}

  -- search and replace
  use {'windwp/nvim-spectre'}
  use {'brooth/far.vim'}

  -- copy pasting
  use {'ojroques/nvim-osc52'}

  -- context
  use {'wellle/context.vim'}

  -- easy motion
  use {'phaazon/hop.nvim'}

  -- windows management
  -- autoscale windows
  use { "beauwilliams/focus.nvim", config = function() require("focus").setup() end }

  -- smooth scrolling
  use 'karb94/neoscroll.nvim'

  -- coc
  use {'neoclide/coc.nvim', branch = 'release'}

  -- multi-select
  use {'mg979/vim-visual-multi'}

  -- python
  use {'Vimjas/vim-python-pep8-indent'}

  -- debugger
  use {'puremourning/vimspector'}

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end



end)
