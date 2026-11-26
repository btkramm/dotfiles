local path = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. '/.config'), 'yazi-path')

vim.api.nvim_create_augroup('yazi', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = 'yazi',
  callback = function(e)
    local file = vim.api.nvim_buf_get_name(e.buf)

    if vim.bo[e.buf].buftype == '' and vim.uv.fs_stat(file) then
      vim.fn.writefile({ file }, path)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'ExitPre' }, {
  group = 'yazi',
  callback = function()
    vim.fn.delete(path)
  end,
})
