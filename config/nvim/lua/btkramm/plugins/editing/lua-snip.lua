return {
  'L3MON4D3/LuaSnip',
  dependencies = {
    'saadparwaiz1/cmp_luasnip',

    'rafamadriz/friendly-snippets',
  },
  build = 'make install_jsregexp',

  config = function()
    require('luasnip.loaders.from_vscode').lazy_load()

    require('luasnip').setup()
  end,
}
