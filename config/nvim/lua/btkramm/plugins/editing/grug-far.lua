local function get_quick_fix_paths()
  local qf_list = vim.fn.getqflist()

  local paths, seen_paths = {}, {}

  for _, item in ipairs(qf_list) do
    local bufnr = item.bufnr

    if bufnr > 0 then
      local filepath = vim.api.nvim_buf_get_name(bufnr)

      if filepath ~= '' and not seen_paths[filepath] then
        table.insert(paths, filepath)

        seen_paths[filepath] = true
      end
    end
  end

  return paths
end

return {
  'MagicDuck/grug-far.nvim',

  opts = {
    enabledEngines = { 'ripgrep', 'astgrep' },

    engines = {
      ripgrep = {
        placeholders = { enabled = false },
      },
      astgrep = {
        placeholders = { enabled = false },
      },
    },

    helpLine = { enabled = false },

    showInputsTopPadding = false,

    keymaps = {
      close = { n = '<localleader>q' },
    },

    icons = { searchInput = '', replaceInput = '', filesFilterInput = '', flagsInput = '', pathsInput = '' },
  },

  keys = {
    {
      '<D-r>',
      function()
        local is_qf = vim.bo.filetype == 'qf'

        if is_qf then
          -- Jump to a normal window first to avoid inheriting the QuickFix's
          -- window height.

          vim.cmd('wincmd p')

          local paths = get_quick_fix_paths()

          require('grug-far').open({
            prefills = { paths = table.concat(paths, '\n') },
          })
        else
          require('grug-far').open()
        end
      end,
      mode = 'n',
      desc = 'Grug Far - Open',
    },
    {
      '<D-r>',
      function()
        local is_qf = vim.bo.filetype == 'qf'

        if is_qf then
          -- Jump to a normal window first to avoid inheriting the QuickFix's
          -- window height.

          vim.cmd('wincmd p')

          local paths = get_quick_fix_paths()

          require('grug-far').with_visual_selection({
            prefills = { paths = table.concat(paths, '\n') },
          })
        else
          require('grug-far').with_visual_selection()
        end
      end,
      mode = 'v',
      desc = 'Grug Far - Open - Visual selection',
    },
  },
}
