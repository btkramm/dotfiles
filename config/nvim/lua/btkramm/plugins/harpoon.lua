return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require('harpoon')

    harpoon:setup()

    vim.keymap.set('n', '§', function()
      harpoon:list():add()
    end)

    vim.keymap.set('n', '<C-D-M-S-h>', function()
      harpoon:list():select(1)
    end)

    vim.keymap.set('n', '<C-D-M-S-j>', function()
      harpoon:list():select(2)
    end)

    vim.keymap.set('n', '<C-D-M-S-k>', function()
      harpoon:list():select(3)
    end)

    vim.keymap.set('n', '<C-D-M-S-l>', function()
      harpoon:list():select(4)
    end)

    vim.keymap.set('n', '<D-i>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list(), {
        border = 'rounded',
        title = ' Marks ',
        title_pos = 'center',
        ui_width_ratio = 0.45,
      })
    end)
  end,
}
