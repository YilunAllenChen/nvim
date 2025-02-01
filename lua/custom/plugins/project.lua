-- jumping between projects
return {
  'ahmedkhalf/project.nvim',
  event = 'VeryLazy',
  config = function()
    require('project_nvim').setup {}
    require('telescope').load_extension 'projects'
  end,
}
