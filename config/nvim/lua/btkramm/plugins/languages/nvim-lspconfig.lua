return {
  'neovim/nvim-lspconfig',
  dependencies = { 'RRethy/vim-illuminate' },

  config = function()
    vim.diagnostic.config({
      float = { border = 'rounded', header = '' },
      virtual_text = true,
    })

    -- Ansible

    vim.lsp.enable('ansiblels')

    -- Bash

    vim.lsp.enable('bashls')

    -- ESLint

    vim.lsp.enable('eslint')

    vim.lsp.config('eslint', {
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          callback = function()
            if client.supports_method('textDocument/codeAction') then
              vim.lsp.buf.code_action({
                context = { only = { 'source.fixAll.eslint' }, diagnostics = {} },
                apply = true,
              })
            end
          end,
        })
      end,
    })

    -- Lua

    vim.lsp.enable('lua_ls')

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    })

    -- Python

    vim.lsp.enable('pyright')

    vim.lsp.config('pyright', {
      filetypes = { 'python' },
      settings = {
        pyright = {
          -- Using Ruff's import organizer

          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            -- Ignore all files for analysis to exclusively use Ruff for
            -- linting

            ignore = { '*' },
          },
        },
      },
    })

    vim.lsp.enable('ruff')

    -- Ruby

    vim.lsp.enable('ruby_lsp')

    vim.lsp.config('ruby_lsp', {
      init_options = {
        formatter = 'standard',
        linters = { 'standard' },
      },
    })

    -- Stylelint

    vim.lsp.enable('stylelint_lsp')

    -- TypeScript

    vim.lsp.enable('ts_ls')

    vim.lsp.config('ts_ls', {
      filetypes = {
        'javascript',
        'javascript.jsx',
        'javascriptreact',
        'typescript',
        'typescript.tsx',
        'typescriptreact',
        'vue',
      },
      init_options = {
        preferences = { disableSuggestions = true },
        plugins = {
          {
            name = '@vue/typescript-plugin',
            location = vim.fn.stdpath('data')
              .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
            languages = { 'vue' },
          },
        },
      },
    })

    -- Vue

    vim.lsp.enable('vue_ls')

    vim.lsp.config('vue_ls', {
      init_options = {
        vue = { hybridMode = false },
      },
    })

    -- YAML

    vim.lsp.enable('yamlls')

    vim.lsp.config('yamlls', {
      settings = {
        yaml = {
          schemas = {
            ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = 'docker-compose*.{yml,yaml}',
          },
        },
      },
    })

    -- Zig

    vim.lsp.enable('zls')
  end,
}
