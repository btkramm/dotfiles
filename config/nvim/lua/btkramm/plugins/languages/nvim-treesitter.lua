return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-context',

      opts = { max_lines = 2 },
    },
  },
  branch = 'main',
  build = ':TSUpdate',
  lazy = false,

  opts = {
    ensure_installed = 'all',

    highlight = { enable = true },

    indent = { enable = true },
  },
}
