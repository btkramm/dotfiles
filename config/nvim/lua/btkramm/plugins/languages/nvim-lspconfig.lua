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
    })

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
      init_options = {
        preferences = {
          disableSuggestions = true,
        },
      },
    })

    -- Zig

    vim.lsp.enable('zls')
  end,
}
