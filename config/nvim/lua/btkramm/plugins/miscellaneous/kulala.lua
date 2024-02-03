return {
  'mistweaverco/kulala.nvim',

  ft = { 'http' },

  opts = {
    global_keymaps = true,

    ui = {
      icons = {
        inlay = { loading = '…', done = '✓', error = '✗' },
      },
    },

    lsp = {
      filetypes = { 'http' },
    },
  },

  keys = {
    { '<leader>Ro', desc = 'Kulala - Open' },
  },
}
