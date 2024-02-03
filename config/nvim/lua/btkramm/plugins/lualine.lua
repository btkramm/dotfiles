local function explore_mode()
  local mark_path = vim.fn.stdpath('data') .. '/sessions/mark'
  local f = io.open(mark_path, 'r')

  if f ~= nil then
    io.close(f)

    return [[-- EXPLORE --]]
  else
    return [[]]
  end
end

return {
  'nvim-lualine/lualine.nvim',
  config = function()
    require('lualine').setup({
      sections = {
        lualine_a = {},
        lualine_b = {
          'branch',
          { 'diff' },
          { 'diagnostics' },
        },
        lualine_c = {
          { 'filename', path = 1 },
          { explore_mode },
        },
        lualine_x = {},
        lualine_y = {
          { 'location' },
        },
        lualine_z = { '' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { 'filename' },
        },
        lualine_x = {},
        lualine_y = {
          { 'location' },
        },
        lualine_z = {},
      },
      options = {
        component_separators = '',
        section_separators = '',
      },
    })
  end,
}
