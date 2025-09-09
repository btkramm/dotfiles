return {
  'stevearc/conform.nvim',

  opts = {
    formatters = {
      shfmt = { args = { '-i', '2', '-bn', '-ci', '-kp', '-s', '-sr' } },
    },

    formatters_by_ft = {
      -- Prettier

      javascript = { 'biome' },
      javascriptreact = { 'biome' },
      typescript = { 'biome' },
      typescriptreact = { 'biome' },

      css = { 'prettierd' },
      html = { 'prettierd' },

      graphql = { 'prettierd' },

      json = { 'prettierd' },
      yaml = { 'prettierd' },

      markdown = { 'prettierd' },

      -- Stylua

      lua = { 'stylua' },

      -- shfmt

      sh = { 'shfmt' },
    },
    format_on_save = { lsp_format = 'fallback' },
  },
}
