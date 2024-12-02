return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
  },
  config = {
    graph_style = 'unicode',
    disable_hint = true,
    use_per_project_settings = false,
    commit_editor = {
      kind = 'split',
    },
    kind = 'vsplit',
    mappings = {
      commit_editor_I = {
        ['<CR>'] = 'Submit',
      },
      rebase_editor_I = {
        ['<CR>'] = 'Submit',
      },
    },
    git_services = {
      ['git.drwholdings.com'] = 'https://git.drwholdings.com/${owner}/${repository}/compare/${branch_name}?expand=1',
    },
  },
}
