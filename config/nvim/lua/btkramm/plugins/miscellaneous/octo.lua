return {
  'pwntester/octo.nvim',
  dependencies = {
    'ibhagwan/fzf-lua',

    'nvim-lua/plenary.nvim',
  },
  lazy = false,

  opts = {
    use_local_fs = true,

    enable_builtin = true,

    ssh_aliases = {
      ['github.com-personal'] = 'github.com',
      ['github.com'] = 'github.com',
    },

    picker = 'fzf-lua',

    file_panel = { use_icons = false },
  },

  keys = {
    { '<leader>o', ':Octo<CR>', desc = 'Octo - Open' },

    { '#', '#<C-x><C-o>', mode = 'i', ft = 'octo' },
    { '@', '@<C-x><C-o>', mode = 'i', ft = 'octo' },
  },
}
