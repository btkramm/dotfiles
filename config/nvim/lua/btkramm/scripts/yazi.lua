vim.api.nvim_create_augroup('yazi', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = 'yazi',
  callback = function(e)
    local path = os.getenv('XDG_CONFIG_HOME') .. '/yazi-path'

    vim.fn.writefile({ e.file }, path)
  end,
})

vim.api.nvim_create_autocmd({ 'ExitPre' }, {
  group = 'yazi',
  callback = function(e)
    local path = os.getenv('XDG_CONFIG_HOME') .. '/yazi-path'

    vim.fn.delete(path)
  end,
})
