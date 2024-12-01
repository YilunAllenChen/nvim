-- utility to create git link from current line
return {
  'ruifm/gitlinker.nvim',
  lazy = true,
  event = 'VeryLazy',
  config = function()
    local gitlinker = require 'gitlinker'
    gitlinker.setup {
      opts = {
        action_callback = gitlinker.copy_to_clipboard,
        print_url = true,
      },
      callbacks = {
        ['git.drwholdings.com'] = function(url_data)
          local url = 'git.drwholdings.com/' .. url_data.repo .. '/blob/' .. url_data.rev .. '/' .. url_data.file
          if url_data.lstart then
            url = url .. '#L' .. url_data.lstart
            if url_data.lend then
              url = url .. '-L' .. url_data.lend
            end
          end
          return url
        end,
      },
      -- default mapping to call url generation with action_callback
      mappings = '<leader>y',
    }
  end,
}
