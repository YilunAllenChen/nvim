local function alpha_render()
  local dashboard = require 'alpha.themes.dashboard'

  -- helper function for utf8 chars
  local function getCharLen(s, pos)
    local byte = string.byte(s, pos)
    if not byte then return nil end
    return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
  end

  local function applyColors(logo, colors, logoColors)
    dashboard.section.header.val = logo

    for key, color in pairs(colors) do
      local name = 'Alpha' .. key
      vim.api.nvim_set_hl(0, name, color)
      colors[key] = name
    end

    dashboard.section.header.opts.hl = {}
    for i, line in ipairs(logoColors) do
      local highlights = {}
      local pos = 0

      for j = 1, #line do
        local opos = pos
        pos = pos + getCharLen(logo[i], opos + 1)

        local color_name = colors[line:sub(j, j)]
        if color_name then table.insert(highlights, { color_name, opos, pos }) end
      end

      table.insert(dashboard.section.header.opts.hl, highlights)
    end
    dashboard.section.buttons.val = {}
    dashboard.config.layout[1].val = vim.fn.max { 10, vim.fn.floor(vim.fn.winheight(0) * 0.3) }
    dashboard.config.layout[3].val = 5
    dashboard.config.opts.noautocmd = true
    return dashboard.opts
  end

  require('alpha').setup(applyColors({
    [[  ███       ███  ]],
    [[  ████      ████ ]],
    [[  ████     █████ ]],
    [[ █ ████    █████ ]],
    [[ ██ ████   █████ ]],
    [[ ███ ████  █████ ]],
    [[ ████ ████ ████ ]],
    [[ █████  ████████ ]],
    [[ █████   ███████ ]],
    [[ █████    ██████ ]],
    [[ █████     █████ ]],
    [[ ████      ████ ]],
    [[  ███       ███  ]],
    [[                    ]],
    [[                    ]],
    [[    Allen's Neovim  ]],
  }, {
    ['b'] = { fg = '#3399ff', ctermfg = 33 },
    ['a'] = { fg = '#53C670', ctermfg = 35 },
    ['g'] = { fg = '#39ac56', ctermfg = 29 },
    ['h'] = { fg = '#33994d', ctermfg = 23 },
    ['i'] = { fg = '#33994d', bg = '#39ac56', ctermfg = 23, ctermbg = 29 },
    ['j'] = { fg = '#53C670', bg = '#33994d', ctermfg = 35, ctermbg = 23 },
    ['k'] = { fg = '#30A572', ctermfg = 36 },
  }, {
    [[  kkkka       gggg  ]],
    [[  kkkkaa      ggggg ]],
    [[ b kkkaaa     ggggg ]],
    [[ bb kkaaaa    ggggg ]],
    [[ bbb kaaaaa   ggggg ]],
    [[ bbbb aaaaaa  ggggg ]],
    [[ bbbbb aaaaaa igggg ]],
    [[ bbbbb  aaaaaahiggg ]],
    [[ bbbbb   aaaaajhigg ]],
    [[ bbbbb    aaaaajhig ]],
    [[ bbbbb     aaaaajhi ]],
    [[ bbbbb      aaaaajh ]],
    [[  bbbb       aaaaa  ]],
    [[                    ]],
    [[                    ]],
    [[  aaaaaaaaabbbbbbb  ]],
  }))

  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    desc = 'Add Alpha dashboard footer',
    once = true,
    callback = function()
      local stats = require('lazy').stats()
      local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
      dashboard.section.footer.val = { ' ', ' ', ' ', 'Started up with ' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
      dashboard.section.footer.opts.hl = 'DashboardFooter'
      pcall(vim.cmd.AlphaRedraw)
    end,
  })
end

return {
  'goolord/alpha-nvim',
  cmd = 'Alpha',
  event = 'VimEnter',
  config = alpha_render,
}
