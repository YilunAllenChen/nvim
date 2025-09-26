return {
  'mfussenegger/nvim-dap',
  dependencies = {
    { 'rcarriga/nvim-dap-ui' },
    { 'theHamsta/nvim-dap-virtual-text' },
    { 'nvim-neotest/nvim-nio' },
    { 'williamboman/mason.nvim' },
    { 'jay-babu/mason-nvim-dap.nvim' },
  },
  config = function()
    local dap = require 'dap'
    local ui = require 'dapui'

    require('dapui').setup {
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            'breakpoints',
            'stacks',
            'watches',
          },
          size = 60, -- 40 columns
          position = 'left',
        },
        {
          elements = {
            'repl',
          },
          size = 0.4,
          position = 'bottom',
        },
      },
    }
    require('nvim-dap-virtual-text').setup {}
    require('mason').setup {}
    require('mason-nvim-dap').setup {
      handlers = {
        function(config) require('mason-nvim-dap').default_setup(config) end,
        python = function(config)
          config.adapters = {
            type = 'executable',
            command = 'python3',
            args = { '-m', 'debugpy.adapter' },
          }
          config.configurations = {
            {
              type = 'python',
              request = 'launch',
              name = '__This File__',
              program = '${file}',
              args = { '/home/alchen/repos/desk-tools/python/configs/dev_process/example.json' },
            },
            {
              type = 'python',
              request = 'launch',
              name = 'Dev Process',
              module = 'fio.desk_tools.apps.dev_process.main',
              args = { '/home/alchen/repos/desk-tools/python/configs/dev_process/example.json' },
            },
            {
              type = 'python',
              request = 'launch',
              name = 'Paper Watcher',
              module = 'fio.desk_tools.apps.paper_watcher.main',
              args = { '/home/alchen/repos/k8s/overlays/paperwatcher/qa/direct-trading-ags/config/config.jsonnet' },
            },
            {
              type = 'python',
              request = 'launch',
              name = 'Empirical Risk',
              module = 'fio.desk_tools.apps.empirical_risk.entry_points.risk_publisher.main',
              args = { 'configs/empirical_risk/risk_publisher/ags.json' },
            },
            {
              type = 'python',
              request = 'launch',
              name = 'Marea Auto Booking',
              module = 'fio.desk_easy_deploy.operations.marea_auto_booking.main',
              args = { '/home/alchen/repos/crypto/configs/marea_auto_booking/test.json' },
            },
          }
          require('mason-nvim-dap').default_setup(config) -- don't forget this!
        end,
      },
    }

    vim.api.nvim_set_hl(0, 'DapBreakpointText', { fg = '#FF0000' })
    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpointText', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapBreakpointText', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })

    dap.listeners.before.event_initialized.dapui_config = ui.open
    dap.listeners.before.event_terminated.dapui_config = ui.close
    dap.listeners.before.event_exited.dapui_config = ui.close
  end,
  keys = {
    { '<leader>dk', function() require('dap').toggle_breakpoint() end, desc = 'Toggle breakpoint' },
    { '<leader>d?', function() require('dapui').eval(nil, { enter = true }) end, desc = 'Evaluate expression' },
    { '<leader>dc', function() require('dap').continue() end, desc = 'Continue' },
    { '<leader>di', function() require('dap').step_into() end, desc = 'Step into' },
    { '<leader>df', function() require('dap').step_over() end, desc = 'Step over' },
    { '<leader>do', function() require('dap').step_out() end, desc = 'Step out' },
    { '<leader>db', function() require('dap').step_back() end, desc = 'Step back' },
    { '<leader>dx', function() require('dap').close() end, desc = 'Stop' },
    { '<leader>dr', function() require('dap').restart() end, desc = 'Restart' },
  },
}
