return {
  'echasnovski/mini.nvim',
  config = function()
    local MiniMap = require('mini.map')

    MiniMap.setup({
      integrations = {
        MiniMap.gen_integration.builtin_search(),
        MiniMap.gen_integration.diagnostic(),
        MiniMap.gen_integration.gitsigns(),
      },
      symbols = {
        encode = MiniMap.gen_encode_symbols.dot('4x2'),
      },
      window = {
        width = 16,
      },
    })

    -- Keymaps

    vim.keymap.set('n', '<leader>mm', MiniMap.toggle)

    vim.keymap.set('n', '<leader>mh', function()
      MiniMap.refresh({ window = { side = 'left' } })
    end)

    vim.keymap.set('n', '<leader>ml', function()
      MiniMap.refresh({ window = { side = 'right' } })
    end)

    for _, key in ipairs({ 'n', 'N', '*', '#' }) do
      local rhs = key .. ':lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>'

      vim.keymap.set('n', key, rhs)
    end
  end,
}
