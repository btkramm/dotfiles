return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',

    'nvim-lua/plenary.nvim',
  },
  lazy = false,

  config = true,

  opts = {
    enable_builtin = true,

    file_panel = { use_icons = false },
  },

  keys = {
    { '<leader>o', ':Octo<CR>', desc = 'Octo - Open' },

    { '#', '#<C-x><C-o>', mode = 'i', ft = 'octo' },
    { '@', '@<C-x><C-o>', mode = 'i', ft = 'octo' },
  },
}
