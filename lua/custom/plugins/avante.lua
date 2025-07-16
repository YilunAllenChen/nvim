return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  opts = {
    provider = 'azure',
    azure = {
      endpoint = 'https://azure-openai.drwcloud.com',
      deployment = 'gpt-4o', -- your desired model (or use gpt-4o, etc.)
      timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
      extra_request_body = {
        max_completion_tokens = 4096, -- Increase this to include reasoning tokens (for reasoning models)
      },
    },
    mappings = {
      sidebar = {
        switch_windows = '<C-j>',
        reverse_switch_windows = '<C-k>',
      },
    },
  },
  build = 'make',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
  },
}
