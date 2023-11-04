return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  opts = {
  },
  config = function()
    require('telescope').setup {
      defaults = {
        prompt_prefix = string.format("%s ", "/"),
        selection_caret = string.format("%s ", ">"),
        path_display = { "full" },
        file_ignore_patterns = { "node_modules", ".mypy_cache", ".pyc", ".git", ".pytest_cache", "target", "**/dist" },
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            prompt_position = "top",
            preview = {
              preview_height = 0.5,
              preview_cutoff = 120,
            },
            mirror = true,
          },
          width = 0.9,
          height = 0.9,
        },
        mappings = {
          -- https://github.com/nvim-telescope/telescope.nvim/issues/2501#issuecomment-1562937344
          i = {
            ["<CR>"] = function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><CR>", true, false, true), "i", false)
            end,
            ["<C-x>"] = function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><C-x>", true, false, true), "i", false)
            end,
            ["<C-v>"] = function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><C-v>", true, false, true), "i", false)
            end,
            ["<C-t>"] = function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><C-t>", true, false, true), "i", false)
            end,
            ["<C-q>"] = function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><C-q>", true, false, true), "i", false)
            end,
            i = { ["<esc>"] = require("telescope.actions").close, },
          },
          n = { ["q"] = require("telescope.actions").close },
        },
      },
    }
    pcall(require('telescope').load_extension, 'fzf')
  end,
}
