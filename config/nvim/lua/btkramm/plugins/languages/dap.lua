return {
  'mfussenegger/nvim-dap',
  dependencies = {
    {
      'microsoft/vscode-js-debug',
      build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
    },
  },
  lazy = false,

  config = function()
    local dap = require('dap')

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        args = {
          vim.fn.stdpath('data') .. '/lazy/vscode-js-debug/out/src/vsDebugServer.js',
          '${port}',
        },
      },
    }

    dap.configurations.typescript = {
      {
        type = 'pwa-node',
        name = 'Attach to React Native',
        request = 'attach',
        port = 8081,
        continueOnAttach = true,

        sourceMaps = true,
        resolveSourceMapLocations = { '**', '!**/node_modules/!(expo)/**' },
        skipFiles = {},
        outFiles = {},
      },
    }

    dap.configurations.typescriptreact = dap.configurations.typescript
  end,

  keys = {
    {
      '<F5>',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'DAP - Toggle Breakpoint',
    },
    {
      '<F6>',
      function()
        require('dap').continue()
      end,
      desc = 'DAP - Start / Continue',
    },
    {
      '<F7>',
      function()
        require('dap').terminate()
      end,
      desc = 'DAP - Terminate',
    },
  },
}
