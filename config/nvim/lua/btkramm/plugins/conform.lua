return {
  'stevearc/conform.nvim',
  config = function()
    local conform = require('conform')

    conform.setup({
      formatters_by_ft = {
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },

        css = { 'prettier' },
        graphql = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        markdown = { 'prettier' },
        yaml = { 'prettier' },

        lua = { 'stylua' },
      },
      format_on_save = {
        lsp_format = 'fallback',
        timeout_ms = 500,
      },
      log_level = vim.log.levels.DEBUG,
    })

    -- Keymaps

    vim.keymap.set({ 'n', 'v' }, '<D-f>', function()
      conform.format({
        lsp_format = 'fallback',
        timeout_ms = 500,
      })
    end)
  end,
}
