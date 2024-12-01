-- jumping between projects
return {
  'ahmedkhalf/project.nvim',
  lazy = true,
  event = 'VeryLazy',
  config = function()
    require('project_nvim').setup {}
    require('telescope').load_extension 'projects'
  end,
}
