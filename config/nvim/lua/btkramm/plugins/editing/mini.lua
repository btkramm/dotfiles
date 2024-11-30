return {
  'echasnovski/mini.nvim',
  event = 'InsertEnter',

  config = function()
    require('mini.ai').setup({
      mappings = {
        around_last = 'aN',
        inside_last = 'iN',

        around_next = 'an',
        inside_next = 'in',
      },
    })

    require('mini.surround').setup({
      mappings = {
        suffix_last = 'N',

        suffix_next = 'n',
      },
    })
  end,
}
