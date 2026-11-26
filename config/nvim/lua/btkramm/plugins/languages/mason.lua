return {
  'williamboman/mason.nvim',
  dependencies = { 'williamboman/mason-lspconfig.nvim' },

  config = function()
    require('mason').setup()

    require('mason-lspconfig').setup({
      automatic_enable = false,

      ensure_installed = {
        'ansiblels',
        'bashls',
        'eslint',
        'lua_ls',
        'pyright',
        'ruff',
        'ts_ls',
        'vue_ls',
        'yamlls',
        'zls',
      },
    })
  end,
}
