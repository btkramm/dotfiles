return {
  'neovim/nvim-lspconfig',
  dependencies = { 'RRethy/vim-illuminate' },

  config = function()
    vim.diagnostic.config({
      float = { border = 'rounded', header = '' },
      virtual_text = true,
    })

    -- Bash

    require('lspconfig').bashls.setup({})

    -- ESLint

    require('lspconfig').eslint.setup({
      on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          command = 'EslintFixAll',
        })
      end,
    })

    -- Lua

    require('lspconfig').lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    })

    -- Python

    require('lspconfig').pyright.setup({
      filetypes = { 'python' },
    })

    -- Ruby

    require('lspconfig').ruby_lsp.setup({
      init_options = {
        formatter = 'standard',
        linters = { 'standard' },
      },
    })

    -- Stylelint

    require('lspconfig').stylelint_lsp.setup({})

    -- TypeScript

    require('lspconfig').ts_ls.setup({
      init_options = {
        preferences = {
          disableSuggestions = true,
        },
      },
    })

    -- Zig

    require('lspconfig').zls.setup({})
  end,
}
