return {
  'monaqa/dial.nvim',
  event = 'InsertEnter',
  config = function()
    local config = require 'dial.config'
    local augend = require 'dial.augend'

    local default = config.augends:get 'default'
    local has_bool = false
    local has_cap_bool = false

    for _, entry in ipairs(default) do
      if entry == augend.constant.alias.bool then has_bool = true end

      if not has_cap_bool and type(entry.elements) == 'table' and #entry.elements == 2 then
        if entry.elements[1] == 'True' and entry.elements[2] == 'False' then has_cap_bool = true end
      end
    end

    if not has_bool then table.insert(default, augend.constant.alias.bool) end
    if not has_cap_bool then table.insert(
      default,
      augend.constant.new {
        elements = { 'True', 'False' },
        word = true,
        cyclic = true,
      }
    ) end
  end,
  keys = {
    { '<C-a>', function() require('dial.map').manipulate('increment', 'normal') end, desc = 'Increment' },
    { '<C-x>', function() require('dial.map').manipulate('decrement', 'normal') end, desc = 'Decrement' },
    { '<C-a>', function() require('dial.map').manipulate('increment', 'visual') end, mode = 'v', desc = 'Increment' },
    { '<C-x>', function() require('dial.map').manipulate('decrement', 'visual') end, mode = 'v', desc = 'Decrement' },
  },
}
