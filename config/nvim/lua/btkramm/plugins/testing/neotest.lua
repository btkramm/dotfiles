return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/neotest-python',
    'nvim-neotest/nvim-nio',

    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },

  config = function()
    local pytest_python_adapter = require('neotest-python')({
      runner = 'pytest',
      args = { '-s' },
      pytest_discover_instances = true,
    })

    require('neotest').setup({
      adapters = { pytest_python_adapter },
      status = { virtual_text = true },
    })
  end,

  keys = {
    {
      '<leader>tt',
      function()
        require('neotest').run.run()
      end,
      desc = 'Test - Run',
    },
    {
      '<leader>tx',
      function()
        require('neotest').run.stop()
      end,
      desc = 'Test - Stop',
    },
    {
      '<leader>tl',
      function()
        require('neotest').run.run_last()
      end,
      desc = 'Test - Run last',
    },
    {
      '<leader>ta',
      function()
        require('neotest').run.run(vim.fn.expand('%'))
      end,
      desc = 'Test - Run all',
    },
    {
      '<leader>ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Test - Toggle summary',
    },
    {
      '<leader>to',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Test - Toggle output panel',
    },
  },
}
