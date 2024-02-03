return {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },

  opts = {
    use_default_keymaps = false,

    max_join_length = 100,

    notify = false,
  },

  keys = {
    {
      '<leader>t',
      function()
        require('treesj').toggle()
      end,
      desc = 'Split / Join syntax tree',
    },
  },
}
