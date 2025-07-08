return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-context',

      opts = { max_lines = 2 },
    },
  },
  build = ':TSUpdate',

  config = function()
    ---@diagnostic disable: missing-fields
    require('nvim-treesitter.configs').setup({
      highlight = { enable = true },

      indent = { enable = true },

      -- nvim-autopairs

      autopairs = { enable = true },

      -- nvim-ts-autotag

      autotag = { enable = false },

      incremental_selection = {
        enable = true,

        keymaps = {
          init_selection = '<CR>',

          node_incremental = '<CR>',
          node_decremental = '<BS>',

          scope_incremental = false,
        },
      },
    })
  end,
}
