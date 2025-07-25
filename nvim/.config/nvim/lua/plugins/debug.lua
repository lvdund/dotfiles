return {
  {
    'andythigpen/nvim-coverage',
    dependencies = 'nvim-lua/plenary.nvim',
    cmd = {
      'Coverage',
      'CoverageSummary',
      'CoverageLoad',
      'CoverageShow',
      'CoverageHide',
      'CoverageToggle',
      'CoverageClear',
    },
    config = function()
      require('coverage').setup()
    end,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'fredrikaverpil/neotest-golang',
    },
    keys = {
      { '<leader>da', "<cmd>lua require('neotest').run.attach()<cr>", desc = 'Attach to the nearest test' },
      { '<leader>dl', "<cmd>lua require('neotest').run.run_last()<cr>", desc = 'Toggle Test Summary' },
      { '<leader>do', "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = 'Toggle Test Output Panel' },
      { '<leader>dp', "<cmd>lua require('neotest').run.stop()<cr>", desc = 'Stop the nearest test' },
      { '<leader>ds', "<cmd>lua require('neotest').summary.toggle()<cr>", desc = 'Toggle Test Summary' },
      { '<leader>dt', "<cmd>lua require('neotest').run.run()<cr>", desc = 'Run the nearest test' },
      {
        '<leader>dT',
        "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
        desc = 'Run test the current file',
      },
      {
        '<leader>td',
        function()
          require('neotest').run.run { suite = false, strategy = 'dap' }
        end,
        desc = 'Debug nearest test',
      },
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-golang'(function()
            local neotest_golang_opts = {} -- Specify custom configuration
            require('neotest').setup {
              adapters = {
                require 'neotest-golang'(neotest_golang_opts), -- Registration
              },
            }
          end), -- Apply configuration
        },
        diagnostic = {
          enabled = false,
        },
        floating = {
          border = 'rounded',
          max_height = 0.6,
          max_width = 0.6,
        },
        highlights = {
          adapter_name = 'NeotestAdapterName',
          border = 'NeotestBorder',
          dir = 'NeotestDir',
          expand_marker = 'NeotestExpandMarker',
          failed = 'NeotestFailed',
          file = 'NeotestFile',
          focused = 'NeotestFocused',
          indent = 'NeotestIndent',
          namespace = 'NeotestNamespace',
          passed = 'NeotestPassed',
          running = 'NeotestRunning',
          skipped = 'NeotestSkipped',
          test = 'NeotestTest',
        },
        output = {
          enabled = true,
          open_on_run = true,
        },
        run = {
          enabled = true,
        },
        status = {
          enabled = true,
        },
        strategies = {
          integrated = {
            height = 40,
            width = 120,
          },
        },
        summary = {
          enabled = true,
          expand_errors = true,
          follow = true,
        },
      }
    end,
  },
}
