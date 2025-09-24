return {
  'mfussenegger/nvim-dap',
  event = 'BufReadPost',
  dependencies = {
    { 'rcarriga/nvim-dap-ui', event = 'BufReadPost' },
    { 'theHamsta/nvim-dap-virtual-text', event = 'BufReadPost' },
    { 'nvim-neotest/nvim-nio', event = 'BufReadPost' },
    { 'williamboman/mason.nvim', event = 'BufReadPost' },
    { 'jay-babu/mason-nvim-dap.nvim', event = 'BufReadPost' },
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
            -- 'console',  -- is this even useful?
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
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
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

    vim.fn.sign_define('DapBreakpoint', { text = '🔴', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapStopped', { text = '👉', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })

    dap.listeners.before.attach.dapui_config = function()
      if require('nvim-tree.api').tree.is_visible() then
        require('nvim-tree.api').tree.close()
      end
      ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      if require('nvim-tree.api').tree.is_visible() then
        require('nvim-tree.api').tree.close()
      end
      ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = ui.close
    dap.listeners.before.event_exited.dapui_config = ui.close
  end,
  keys = {

    -- DAP
    {
      '<space>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Toggle breakpoint',
    },
    {
      '<space>?',
      function()
        require('dapui').eval(nil, { enter = true })
      end,
      desc = 'Evaluate expression',
    },
    {
      '<F1>',
      function()
        require('dap').continue()
      end,
      desc = 'Continue',
    },
    {
      '<F2>',
      function()
        require('dap').step_into()
      end,
      desc = 'Step into',
    },
    {
      '<F3>',
      function()
        require('dap').step_over()
      end,
      desc = 'Step over',
    },
    {
      '<F4>',
      function()
        require('dap').step_out()
      end,
      desc = 'Step out',
    },
    {
      '<F5>',
      function()
        require('dap').step_back()
      end,
      desc = 'Step back',
    },
    {
      '<F11>',
      function()
        require('dap').close()
      end,
      desc = 'Stop',
    },
    {
      '<F12>',
      function()
        require('dap').restart()
      end,
      desc = 'Restart',
    },
  },
}
